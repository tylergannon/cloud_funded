require 'spec_helper'

feature "Team Membership" do
  background do
    sign_in_member
    @project = FactoryGirl.create :full_project
  end
  
  describe "Confirming Membership", js: true do
    background do
      @role = FactoryGirl.create :projects_role, member: @member, email_address: @member.email, project: @project
      assert Ability.new(@member).can?(:edit, @role)
    end
    scenario "I should be able to confirm my role on a team" do
      visit account_path
      current_path.should == account_path
      page.should have_link('Confirm')
      answer_yes_to_confirmations
      click_link 'Confirm'
      wait_until(2) do
        page.has_content?('Confirmed')
      end
    end
  end
end

