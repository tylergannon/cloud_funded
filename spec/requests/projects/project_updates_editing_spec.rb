require 'spec_helper'

feature "Project owners can edit updates" do
  background do
    sign_in_member
    FactoryGirl.create :full_project, owner: @member
  end

  scenario "Add an update" do
    current_path.should == root_path
    
    
  end
end

