require 'spec_helper'

feature "Pledging For A Project" do
  background do
    sign_in_member
    @project = FactoryGirl.create :full_project
  end
  
  describe "when I don't have a dwolla account" do
    scenario "I should be able to submit my pledge and then pay." do
      visit project_path(@project)
      click_link 'new_pledge'
      current_path.should == new_project_pledge_path(@project)
      fill_in 'pledge_amount', with: 1000
      choose "pledge_perk_id_#{@project.perks.first.id}"
      click_button 'Contribute!'
      
      puts page.body
      # sleep(9000)
      current_path.should == new_project_pledge_path(@project, 'choose_payment_method')
      @pledge = @member.pledge_for(@project)
      @pledge.should be_choose_payment_method
      choose 'payment_method_cc'
      click_button 'Choose Payment Method'
      @pledge.reload
      @pledge.payment_method.should == 'cc'
      @pledge.should be_pay_by_cc

      within '.pay' do
        fill_in 'cc_number', with: '4242424242424242'
        fill_in 'cc_cvc', with: '123'
        fill_in 'cc_month', with: '12'
        fill_in 'cc_year', with: (Date.today.year+1)
        click_button 'Pay'
      end
      page.should have_content 'Thanks!'
      @pledge.reload
      @pledge.should be_payment_received
    end
    
    scenario "Paying with a declined credit card", js: true do
      VCR.use_cassette "features/project_pledge_spec/Paying with a declined credit card" do
        @pledge = FactoryGirl.create :pledge_pay_by_cc, investor: @member, project: @project, perk: @project.perks[0]
        visit new_project_pledge_path(@project, 'pay_by_cc')
        within '.pay' do
          fill_in 'cc_number', with: '4000000000000002'
          fill_in 'cc_cvc', with: '123'
          fill_in 'cc_month', with: '12'
          fill_in 'cc_year', with: (Date.today.year+1)
          click_button 'Pay'
        end
        wait_until(5) do
          page.has_selector?('.payment_error')
        end
        within '.payment_error' do
          page.should have_content("Your card was declined")
        end
      end
    end
  end
end