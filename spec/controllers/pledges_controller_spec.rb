require 'spec_helper'

describe PledgesController do
  before :each do 
    Project.any_instance.stub(:save_attached_files).and_return(true)
    Project.any_instance.stub(:destroy_attached_files).and_return(true)
    Paperclip::Attachment.any_instance.stub(:queue_all_for_delete).and_return(true)
    @member = FactoryGirl.create(:member)
    @project = FactoryGirl.create :project
  end

  # This should return the minimal set of attributes required to create a valid
  # Pledge. As you add validations to Pledge, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {amount: 123.45, investor: @member}
  end
  
  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # PledgesController. Be sure to keep this updated too.
  def valid_session
    {}
  end

  describe "GET index" do
    it "assigns all pledges as @pledges" do
      pledge = @project.pledges.create! investor: @member, amount: 123.45
      get :index, {project_id: @project.id}
      assigns(:pledges).should eq([pledge])
    end
  end

  describe "GET show" do
    describe "if accessed with a pledge id" do
      before :each do
        @pledge = @project.pledges.create! investor: @member, amount: 123.45
        get :show, {:project_id => @project.id, :id => @pledge.to_param}
      end
      it "assigns the requested pledge as @pledge" do
        assigns(:pledge).should eq(@pledge)
      end
      it "should render the 'show' template" do
        response.should render_template('show')
      end
    end
    describe "if accessed without a pledge id" do
      before :each do
        sign_in :member, @member
        @pledge = FactoryGirl.create :pledge, investor: @member, project: @project
        get :show, {project_id: @project.id}
      end
      it "should load the pledge owned by the member" do
        assigns(:pledge).should eq(@pledge)
      end
      it "should render the 'show_my_pledge' template" do
        response.should render_template('show_my_pledge')
      end
    end
  end
  
  describe "authentication required" do
    before :each do
      request.env["devise.mapping"] = Devise.mappings[:member]
      sign_in :member, @member
    end

    describe "GET new" do
      it "assigns a new pledge as @pledge" do
        get :new, {:project_id => @project.id}
        controller.member_signed_in?.should be_true
        assigns(:pledge).should be_a_new(Pledge)
      end
    end

    describe "GET edit" do
      it "assigns the requested pledge as @pledge" do
        pledge = @project.pledges.create! valid_attributes
        get :edit, {:project_id => @project.id, :id => pledge.to_param}
        assigns(:pledge).should eq(pledge)
      end

      describe "if accessed without a pledge id" do
        before :each do
          sign_in :member, @member
        end
        it "should load the pledge owned by the member" do
          pledge = FactoryGirl.create :pledge, investor: @member, project: @project
          get :edit, {project_id: @project.id}
          assigns(:pledge).should eq(pledge)
        end
      end
    end

    describe "POST create" do
      before :each do
        CloudFunded::Facebook::Actions.stub(:pledge_to_support)
      end
      describe "with valid params" do
        it "creates a new Pledge" do
          expect {
            post :create, {:project_id => @project.id, :pledge => valid_attributes}
          }.to change(Pledge, :count).by(1)
        end

        it "assigns a newly created pledge as @pledge" do
          post :create, {:project_id => @project.id, :pledge => valid_attributes}
          assigns(:pledge).should be_a(Pledge)
          assigns(:pledge).should be_persisted
        end

        it "redirects to the created pledge" do
          post :create, {:project_id => @project.id, :pledge => valid_attributes}
          response.should redirect_to(project_my_pledge_path(@project))
        end
        it "should call the create project facebook action" do
          CloudFunded::Facebook::Actions.should_receive(:pledge_to_support) do |proj_url, access_token|
            proj_url.should == project_url(assigns(:project))
            access_token.should == @member.fb_token
          end
          post :create, {:pledge => valid_attributes, :project_id => @project.id}
        end

        it "should not call the create project if post_to_fb not checked." do
          CloudFunded::Facebook::Actions.should_not_receive(:pledge_to_support)
          post :create, {:pledge => valid_attributes.merge(post_to_fb: false), :project_id => @project.id}
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved pledge as @pledge" do
          # Trigger the behavior that occurs when invalid params are submitted
          Pledge.any_instance.stub(:save).and_return(false)
          post :create, {:project_id => @project.id, :pledge => {}}
          assigns(:pledge).should be_a_new(Pledge)
        end

        it "re-renders the 'new' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          Pledge.any_instance.stub(:save).and_return(false)
          post :create, {:project_id => @project.id, :pledge => {}}
        end
      end
    end

    describe "PUT update" do
      describe "with valid params" do
        it "updates the requested pledge" do
          pledge = @project.pledges.create! valid_attributes
          # Assuming there are no other pledges in the database, this
          # specifies that the Pledge created on the previous line
          # receives the :update_attributes message with whatever params are
          # submitted in the request.
          Pledge.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
          put :update, {:project_id => @project.id, :id => pledge.to_param, :pledge => {'these' => 'params'}}
        end

        it "assigns the requested pledge as @pledge" do
          pledge = @project.pledges.create! valid_attributes
          put :update, {:project_id => @project.id, :id => pledge.to_param, :pledge => {amount: 123.45}}
          assigns(:pledge).should eq(pledge)
        end

        it "redirects to the pledge" do
          pledge = @project.pledges.create! valid_attributes
          put :update, {:project_id => @project.id, :id => pledge.to_param, :pledge => {amount: 123.45}}
          response.should redirect_to(project_pledge_path(@project, pledge))
        end
      end

      describe "with invalid params" do
        it "assigns the pledge as @pledge" do
          pledge = @project.pledges.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          Pledge.any_instance.stub(:save).and_return(false)
          put :update, {:project_id => @project.id, :id => pledge.to_param, :pledge => {}}
          assigns(:pledge).should eq(pledge)
        end

        it "re-renders the 'edit' template" do
          pledge = @project.pledges.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          Pledge.any_instance.stub(:save).and_return(false)
          put :update, {:project_id => @project.id, :id => pledge.to_param, :pledge => {}}
        end
      end
    end

    describe "DELETE destroy" do
      it "destroys the requested pledge" do
        pledge = @project.pledges.create! valid_attributes
        expect {
          delete :destroy, {:project_id => @project.id, :id => pledge.to_param}
        }.to change(Pledge, :count).by(-1)
      end

      it "redirects to the pledges list" do
        pledge = @project.pledges.create! valid_attributes
        delete :destroy, {:project_id => @project.id, :id => pledge.to_param}
        response.should redirect_to(project_pledges_path(@project))
      end
    end
  end
end
