require 'spec_helper'

describe Projects::WizardController do
  describe "get #show" do
    before :each do
      sign_in_as_member
      @project = FactoryGirl.create :project, owner: @member, published: true
    end
    
    describe "when :project_id is present" do
      it "should load the project" do
        get :show, project_id: @project.to_param
        assigns(:project).should == @project
      end
      describe "and I don't own the project" do
        before :each do
          @another_project = FactoryGirl.create :project
          get :show, project_id: @another_project.to_param
        end
        it "should be unauthorized" do
          response.status.should == 404
        end
      end
    end
    describe "when :project_id is not present" do
      describe "and the member already has a current application" do
        before :each do
          @project_application = @member.project_application
        end
        it "should load the member's project application" do
          expect {
            get :show
            assigns(:project).should == @project_application
          }.to change(Project, :count).by(0)
        end
      end
      describe "and the member doesn't have a current application" do
        it "should create a new project" do
          expect {
            get :show
            assigns(:project).should_not == @project
          }.to change(Project, :count).by(1)
        end
      end
    end
  end
end