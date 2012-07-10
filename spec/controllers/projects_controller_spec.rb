require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe ProjectsController do
  before :each do 
    sign_in_as_member
    stub_attachments_for(Project)
    @example_project = FactoryGirl.create(:project, owner: @member)
    image = @example_project.image
    # Project.any_instance.stub(:image).and_return(image)
  end
  
  # This should return the minimal set of attributes required to create a valid
  # Project. As you add validations to Project, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    another_project = FactoryGirl.build(:project, owner: @member)
    {
      name: another_project.name,
      description: another_project.description,
      financial_goal: another_project.financial_goal,
      website_url: another_project.website_url,
      category_id: another_project.category_id,
      address: 'nicebas',
      lat: 123,
      long: 123,
      image: fixture_file_upload('spec/support/onebit_33.png')
    }
  end
  
  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # ProjectsController. Be sure to keep this updated too.
  def valid_session
    {}
  end

  describe "GET index" do
    it "assigns all projects as @projects" do
      project = FactoryGirl.create(:project, {owner: @member})
      get :index, {}
      assigns(:projects).should eq([@example_project, project])
    end
    describe "when showing my projects" do
      before :each do
        3.times {FactoryGirl.create :project}
        @my_project = FactoryGirl.create :project, owner: @member
        get :index, {show: :mine}
      end
      it "loads only my projects" do
        assigns(:projects).should eq([@example_project, @my_project])
      end
      it "renders the my_projects action" do
        response.should render_template('my_projects')
      end 
    end
  end

  describe "GET show" do
    it "assigns the requested project as @project" do
      project = FactoryGirl.create(:project, {owner: @member})
      get :show, {:id => project.to_param}
      assigns(:project).should eq(project)
    end
    describe "Seeing My Pledge" do
      before :each do
        @project_i_am_viewing = FactoryGirl.create :project
      end
      describe "when I have not pledged support" do
        it "should have a nil value for @my_pledge" do
          get :show, {id: @project_i_am_viewing.to_param}
          assigns(:my_pledge).should be_nil
        end
      end
      describe "when I have pledged support" do
        it "should assign my pledge" do
          pledge = FactoryGirl.create :pledge, project: @project_i_am_viewing, investor: @member
          get :show, {id: @project_i_am_viewing.to_param}
          assigns(:my_pledge).should == pledge
        end
      end
    end
  end

  describe "GET new" do
    it "assigns a new project as @project" do
      get :new, {}
      assigns(:project).should be_a_new(Project)
    end
  end

  describe "GET edit" do
    it "assigns the requested project as @project" do
      project = FactoryGirl.create(:project, {owner: @member})
      get :edit, {:id => project.to_param}
      assigns(:project).should eq(project)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      before :each do
        CloudFunded::Facebook::Actions.stub(:create_project)
      end
      it "creates a new Project" do
        expect {
          post :create, {:project => valid_attributes}
        }.to change(Project, :count).by(1)
      end

      it "assigns a newly created project as @project" do
        post :create, {:project => valid_attributes}
        assigns(:project).should be_a(Project)
        assigns(:project).should be_persisted
      end

      it "redirects to the created project" do
        post :create, {:project => valid_attributes}
        response.should redirect_to(project_wizard_path(Project.last))
      end
      
      it "should call the create project facebook action" do
        CloudFunded::Facebook::Actions.should_receive(:create_project) do |proj_url, access_token|
          proj_url.should == project_url(assigns(:project))
          access_token.should == @member.fb_token
        end
        post :create, {:project => valid_attributes}
      end
      
      it "should not call the create project if post_to_fb not checked." do
        CloudFunded::Facebook::Actions.should_not_receive(:create_project)
        post :create, {:project => valid_attributes.merge(post_to_fb: false)}
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved project as @project" do
        # Trigger the behavior that occurs when invalid params are submitted
        Project.any_instance.stub(:save).and_return(false)
        post :create, {:project => {}}
        assigns(:project).should be_a_new(Project)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Project.any_instance.stub(:save).and_return(false)
        post :create, {:project => {}}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested project" do
        project = FactoryGirl.create(:project, {owner: @member})
        # Assuming there are no other projects in the database, this
        # specifies that the Project created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Project.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, {:id => project.to_param, :project => {'these' => 'params'}}
      end

      it "assigns the requested project as @project" do
        project = FactoryGirl.create(:project, {owner: @member})
        put :update, {:id => project.to_param, :project => valid_attributes}
        assigns(:project).should eq(project)
      end

      it "redirects to the project" do
        project = FactoryGirl.create(:project, {owner: @member})
        put :update, {:id => project.to_param, :project => {description: 'nice'}}
        response.should redirect_to(project)
      end
    end

    describe "with invalid params" do
      it "assigns the project as @project" do
        project = FactoryGirl.create(:project, {owner: @member})
        # Trigger the behavior that occurs when invalid params are submitted
        Project.any_instance.stub(:save).and_return(false)
        put :update, {:id => project.to_param, :project => {}}
        assigns(:project).should eq(project)
      end

      it "re-renders the 'edit' template" do
        project = FactoryGirl.create(:project, {owner: @member})
        # Trigger the behavior that occurs when invalid params are submitted
        Project.any_instance.stub(:save).and_return(false)
        put :update, {:id => project.to_param, :project => {}}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    before :each do
      @member.admin = true
      @member.save!
    end
    it "destroys the requested project" do
      project = FactoryGirl.create(:project, {owner: @member})
      expect {
        delete :destroy, {:id => project.to_param}
      }.to change(Project, :count).by(-1)
    end

    # it "redirects to the projects list" do
    #   project = FactoryGirl.create(:project, {owner: @member})
    #   delete :destroy, {:id => project.to_param}
    #   response.should redirect_to(projects_url)
    # end
  end

end
