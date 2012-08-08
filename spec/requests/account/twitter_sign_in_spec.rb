require 'spec_helper'

feature "Signing In With Twitter" do
  # background do
  #   sign_in_member
  # end
  # 
  scenario "When I don" do
    click_link 'My Account'
    page.should have_selector('.transaction_history td.amount')
    find('.transaction_history td.amount').text.should == "$9.99"
  end
end

