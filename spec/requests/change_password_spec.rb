require 'spec_helper'

feature "User can change password" do
  background do
    @password = 'nicebaq'
    @member = FactoryGirl.create :member, email: 'smartie@groovy.com', password: @password, password_confirmation: 'nicebaq'
  end

  scenario "Creating a user account and then signing in" do
    sign_in_member
    current_path.should == root_path
    
    
  end
end

