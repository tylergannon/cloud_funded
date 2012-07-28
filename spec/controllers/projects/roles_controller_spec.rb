require 'spec_helper'

describe Projects::RolesController do
  before :each do
    sign_in_as_member
    @project = FactoryGirl.create :live_project, owner: @member
  end
  
  def valid_params 
    {
      name: 'Supreme Overlord',
      email_address: 'tgannon@gmail.com',
      tagline: 'Does everything that\'s worth doing.'
    }
  end
  
  def invalid_params
    {}
  end
  
  describe '#new.js' do
    describe "when I can manage the project" do
      before :each do
        get :new, project_id: @project.to_param, format: :js
      end
      it "should not redirect" do
        response.should_not be_redirect
      end
      it "should return a 200" do
        response.status.should == 200
      end
      it "should render the new template" do
        response.should render_template('new')
      end
    end
    describe "when I don't own the project" do
      before :each do
        @member = FactoryGirl.create :member
        sign_in_as_member
        get :new, project_id: @project.to_param, format: :js
      end
      it "should be unauthorized" do
        response.status.should == 401
      end
    end
  end
  describe '#create.js' do
    describe "when I can edit the project" do
      describe "when the added member exists" do
        before(:each) do
          @added_member = FactoryGirl.create :member, email: valid_params[:email_address]
          post :create, role: valid_params, project_id: @project.to_param, format: :js
          @project.reload
          @new_role = @project.roles.last
        end
        it "should have the correct member attached to it" do
          @new_role.member.should == @added_member
        end
      end
      
      describe "with valid params" do
        before(:each) do
          post :create, role: valid_params, project_id: @project.to_param, format: :js
          @project.reload
          @new_role = @project.roles.last
        end
        it "should respond with success" do
          response.status.should == 200
        end
        it "should render the create action" do
          response.should render_template('create')
        end
        it "should create a new role" do
          @new_role.should_not be_nil
        end
        it "should have the correct email" do
          @new_role.email_address.should == valid_params[:email_address]
        end
        it "should have the correct name" do
          @new_role.name.should == valid_params[:name]
        end
        it "should have the correct tagline" do
          @new_role.tagline.should == valid_params[:tagline]
        end
        it "should have the correct tagline" do
          @new_role.invited_by.should == @member
        end
        it "should have the correct project" do
          @new_role.project.should == @project
        end
      end
    end

    describe "when I can't edit the project" do
      before :each do
        @member = FactoryGirl.create :member
        sign_in_as_member
        post :create, project_id: @project.to_param, format: :js
      end
      it "should be unauthorized" do
        response.status.should == 401
      end
    end
  end

  describe 'GET #confirm' do
    describe "When I am not the person who was invited" do
      before(:each) do
        @role = FactoryGirl.create :projects_role, project: @project
        get :confirm, project_id: @project.to_param, id: @role.id, format: :js
      end
      it "should respond with 401" do
        response.status.should == 401
      end
      it "should not confirm the role" do
        @role.reload
        @role.should_not be_confirmed
      end
    end
    describe "when I am the person who was invited" do
      before(:each) do
        @role = FactoryGirl.create :projects_role, project: @project, member: @member
        get :confirm, project_id: @project.to_param, id: @role.id, format: :js
      end
      it "should respond with 200" do
        response.status.should == 200
      end
      it "should render the confirm action" do
        response.should render_template('confirm')
      end
      it "should confirm the role" do
        @role.reload
        @role.should be_confirmed
      end
    end
  end

  describe 'DELETE #destroy.js' do
    before(:each) do
      @role = FactoryGirl.create :projects_role, project: @project
    end
    describe "when I can edit the project" do
      it "should destroy the role" do
        expect {
          delete :destroy, project_id: @project.to_param, id: @role.id, format: :js
        }.to change(Projects::Role, :count).by(-1)
      end
      describe "other results" do
        before(:each) do
          delete :destroy, project_id: @project.to_param, id: @role.id, format: :js
        end
        it "should respond with success" do
          response.status.should == 200
        end
        it "should render the destroy action" do
          response.should render_template('destroy')
        end
      end
    end
    
    describe "when I don't own the project" do
      before :each do
        @member = FactoryGirl.create :member
        sign_in_as_member
        delete :destroy, project_id: @project.to_param, id: @role.id, format: :js
      end
      it "should be unauthorized" do
        response.status.should == 401
      end
    end
  end
end
