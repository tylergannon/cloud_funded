require 'spec_helper'

feature "Signing up" do
  background do
    Members::RegistrationsController.any_instance.stub(:verify_recaptcha).and_return true
    # User.make(:email => 'user@example.com', :password => 'caplin')
  end

  scenario "Creating a user account and then signing in" do
    visit new_member_registration_path
    fill_in 'First name', with: 'Somebody'
    fill_in 'Last name', with: 'New'
    fill_in 'Email', with: 'somebodynewboy@gmail.com'
    fill_in 'Password', with: 'myfunkypass'
    fill_in 'Password confirmation', with: 'myfunkypass'
    click_button 'Sign up'
    # puts page.source
    if page.has_selector? 'div#error_explanation'
      puts find('div#error_explanation').text
    end
    # <p class="alert">There was an error with the recaptcha code below. Please re-enter the code.</p>
    
    URI.parse(current_url).path.should == root_path
    
    Member.where(email: 'somebodynewboy@gmail.com').should exist

    @member = Member.where(email: 'somebodynewboy@gmail.com').first

    @member.confirm!
    @member.save!
    
    visit new_member_session_path
    fill_in 'Email', with: @member.email
    fill_in 'Password', with: 'myfunkypass'
    click_button 'Sign in'    
    URI.parse(current_url).path.should == root_path
  end
end

