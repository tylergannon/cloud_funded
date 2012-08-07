require 'spec_helper'

describe Projects::PledgeWizardController do
  render_views
  
  before :each do
    @project = FactoryGirl.create :project, name: 'walmart'
  end
  
  describe "when not signed in" do
    it "should redirect to the sign_in page" do
      get :show, project_id: 'walmart'
      response.should redirect_to(new_member_session_path)
    end
  end
    
  describe "when signed in" do
    before :each do
      sign_in_as_member
      @perk = @project.perks[0]
      @perk.update_attributes price: 50
    end
    describe "Step 1 pledge" do
      describe "when perk is selected and pledge amount is greater than the perk price" do
        before :each do
          put :update, project_id: @project.to_param, pledge: {
            perk_id: @perk.id,
            amount: 50
          }
          @pledge = @member.pledge_for(@project)
        end
        it {should redirect_to(new_project_pledge_path(@project, 'payment_method'))}
        it "should transition the pledge to the pledged state" do
          @pledge.should be_choose_payment_method
        end
        
        
      end
      describe "when no perk is selected" do
        before :each do
          put :update, project_id: @project.to_param, pledge: {
            amount: 49
          }
        end
        subject {response}
        it "should not be valid" do
          assigns(:pledge).should_not be_valid
        end
        it {should render_template('pledge')}
        it {should_not be_redirect}
      end
      
      describe "when the pledge amount is lower than the selected perk" do
        before :each do
          @perk = @project.perks[0]
          @perk.update_attributes price: 50
          put :update, project_id: @project.to_param, pledge: {
            perk_id: @perk.id,
            amount: 49
          }
        end
        subject {response}
        it {should render_template('pledge')}
        it {should_not be_redirect}
      end
    end
    
    describe "redirect to the correct step" do
      it "should redirect to new if the pledge is new" do
        get :show, id: 'choose_payment_method', project_id: @project.to_param
        response.should redirect_to(new_project_pledge_path(@project, id: 'amount'))
      end
      it "should redirect a PUT to new if the pledge is new" do
        put :update, id: 'choose_payment_method', project_id: @project.to_param
        response.should redirect_to(new_project_pledge_path(@project, id: 'amount'))
      end
      it "should redirect to choose_payment_method if that's the pledge state" do
        @pledge = FactoryGirl.create :pledge_choose_payment_method, 
                        project: @project, 
                        perk: @project.perks[0],
                        investor: @member
        get :show, project_id: @project.to_param
        response.should redirect_to(new_project_pledge_path(@project, id: 'payment_method'))
        
      end
    end

    describe "Step 2 Choose Payment Method" do
      describe "choose pay by cc" do
        before :each do
          @pledge = FactoryGirl.create :pledge_choose_payment_method, 
                          project: @project, 
                          perk: @project.perks[0],
                          investor: @member
          put :update, id: 'payment_method', project_id: @project.to_param, pledge: {payment_method: 'cc'}
          @pledge.reload
        end
        it "should be moved to the pay_by_cc state" do
          @pledge.should be_pay_by_cc
        end
        it "should have cc as the payment method" do
          @pledge.payment_method.should == 'cc'
        end
      end
    end

    describe "Pay By CC" do
      before :each do
        @pledge = FactoryGirl.create :pledge_pay_by_cc, 
                        project: @project, 
                        perk: @project.perks[0],
                        investor: @member
        VCR.use_cassette "Successful Stripe Payment" do
          expect {
            put :update, id: 'pay_by_cc', project_id: @project.to_param, stripe_token: 'tok_03oAdsIepzByXP'
          }.to change(StripeTransaction, :count).by(1)
        end
      end
      it "should have the correct pledge amount" do
        assigns(:stripe_transaction).amount.should == @pledge.amount
      end
      it "should load the correct pledge" do
        assigns(:pledge).should == @pledge
      end
      it "should set the pledge status to 'payment_received'" do
        assigns(:pledge).should be_payment_received
      end
      it "should redirect to share" do
        response.should redirect_to(new_project_pledge_path(@project, 'share'))
      end
    end
  end
end