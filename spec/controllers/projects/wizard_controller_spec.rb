require 'spec_helper'

describe Projects::WizardController do
  describe "get #show" do
    before :each do
      sign_in_as_member
    end
    
    describe "going to preview" do
      before :each do
        @project = FactoryGirl.create :project, owner: @member
      end
      describe "when submitting to see preview" do
        it "should call submitted_fund_raise" do
          controller.should_receive(:submit_fund_raise)
          put :update, project_id: @project.to_param, id: 'fund_raise'
        end
        it "should change the workflow state to :previewing" do
          @project.should be_new
          put :update, project_id: @project.to_param, id: 'fund_raise'
          @project.reload
          @project.should be_new
        end
        it "should redirect to the preview page" do
          put :update, project_id: @project.to_param, id: 'fund_raise'
          response.should render_template('fund_raise')
        end
      end
      
      describe "when submitting the application" do
        before :each do
          Project.any_instance.stub(:valid?).and_return true
          @project.reload
          @project.preview!
          put :update, project_id: @project.to_param, id: 'preview'
          @project.reload
        end
        it "should go to awaiting review" do
          @project.should be_being_reviewed
        end
        it "should go to the next thing" do
          response.should redirect_to(project_wizard_path(@project, 'submitted'))
        end
      end
    end
    
    describe "project loading" do
      before :each do
        @project = FactoryGirl.create :project, owner: @member
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
end