require 'spec_helper'

feature "Pledging For A Project" do
  background do
    sign_in_member
    @project = FactoryGirl.create :live_project
  end
  describe "when I don't have a dwolla account", js: true do
    scenario "I should be able to submit my pledge and then sign up for dwolla." do
      visit project_path(@project)
      click_link 'new_pledge'
      current_path.should == new_project_pledge_path(@project)
      fill_in 'pledge_amount', with: 1000
      choose "pledge_perk_id_#{@project.perks.first.id}"
      click_button 'Contribute!'
      
    end
  end
end