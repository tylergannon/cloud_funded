require 'spec_helper'

describe Projects::PledgeWizardController do
  render_views
  
  before :each do
    @project = FactoryGirl.create :project, name: 'walmart'
  end
  
  describe "when not signed in" do
    it "should redirect to the sign_in page" do
      get :show, project_id: 'walmart'
      response.should redirect_to(new_member_session_path)
    end
  end
  
  describe "when signed in" do
    before :each do
      sign_in_as_member
    end
    describe "Step 1 pledge" do
      describe "when perk is selected and pledge amount is greater than the perk price" do
        before :each do
          @perk = @project.perks[0]
          @perk.update_attributes price: 50
          put :update, project_id: @project.to_param, pledge: {
            perk_id: @perk.id,
            amount: 50
          }
          @pledge = @member.pledge_for(@project)
        end
        it {should redirect_to(new_project_pledge_path(@project, 'pay'))}
        it "should transition the pledge to the pledged state" do
          @pledge.should be_pledged
        end
        
        
      end
      describe "when no perk is selected" do
        before :each do
          put :update, project_id: @project.to_param, pledge: {
            amount: 49
          }
        end
        subject {response}
        it "should not be valid" do
          assigns(:pledge).should_not be_valid
        end
        it {should render_template('pledge')}
        it {should_not be_redirect}
      end
      
      describe "when the pledge amount is lower than the selected perk" do
        before :each do
          @perk = @project.perks[0]
          @perk.update_attributes price: 50
          put :update, project_id: @project.to_param, pledge: {
            perk_id: @perk.id,
            amount: 49
          }
        end
        subject {response}
        it {should render_template('pledge')}
        it {should_not be_redirect}
      end
    end
  end
end