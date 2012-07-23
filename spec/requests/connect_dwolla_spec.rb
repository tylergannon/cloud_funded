require 'spec_helper'

feature "connecting dwolla account" do
  background do
    sign_in_member
  end
  
  scenario "when I already have a dwolla account" do
    visit account_path
    page.should have_link 'Link Dwolla Account'
    click_link 'Link Dwolla Account'
    sleep 1
    puts page.driver.browser.window_handles.last.inspect
  end
end