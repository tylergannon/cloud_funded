require 'spec_helper'

feature "My Account Page" do
  background do
    sign_in_member
    @transaction = FactoryGirl.create :transaction, member: @member, amount: 9.99
  end

  scenario "View my account page" do
    click_link 'My Account'
    page.should have_selector('.transaction_history td.amount')
    find('.transaction_history td.amount').text.should == "$9.99"
  end
end

