require 'spec_helper'

feature "connecting dwolla account" do
  background do
    Capybara.reset_sessions!
    sign_in_member
  end
  
  scenario "when I already have a dwolla account", js: true do
    visit account_path
    answer_yes_to_confirmations
    click_link 'Unlink Your Account'
    if (page.has_link?('Unlink Your Account'))
      
    end
  
    # sleep 9000
    page.should have_link 'Link Dwolla Account'
    click_link 'Link Dwolla Account'
    # wait_until(1) do
    #   page.find('#dwolla').visible?
    # end
    within_frame('dwolla') do
      fill_in('email', with: 'tgannon@gmail.com')
      fill_in('password', with: 'Mr.C00l!')
      click_button('Sign In')
      click_button('Allow')
    end
    wait_until(10) do
      page.has_link('Unlink Your Account')
    end
    page.should have_content('You have linked to Dwolla account 812-674-6295.')
  end
end