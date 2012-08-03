require 'spec_helper'

describe Members::TransactionsController do
  describe '#create' do
    describe "when the pin number is incorrect" do
      before :each do
        @member = FactoryGirl.create :member, dwolla_auth_token: "TuJ7nmmyGksCZAk2OXi1q7btY6wJou71gUMl6IS/0Pcs74si5J"
        sign_in @member
      end
      it "should not create a new transaction" do
        VCR.use_cassette 'Fund My Account Wrong Pin' do
          lambda {
            post :create, {amount: 0.01, pin: 1234}
          }.should_not change(Transaction, :count)
        end
      end
      it "should re-render the new action" do
        VCR.use_cassette 'Fund My Account Wrong Pin' do
          post :create, {amount: 0.01, pin: 1234}
        end
        response.should render_template(:new)
      end
    end

    describe "when the amount number is incorrect" do
      before :each do
        @member = FactoryGirl.create :member, dwolla_auth_token: "TuJ7nmmyGksCZAk2OXi1q7btY6wJou71gUMl6IS/0Pcs74si5J"
        sign_in @member
      end
      it "should not create a new transaction" do
        VCR.use_cassette 'Fund My Account Invalid Amount' do
          lambda {
            post :create, {amount: 'nicebar', pin: 1234}
          }.should_not change(Transaction, :count)
        end
      end
    end
    
    describe "when the access token is invalid" do
      # Invalid access token
      before :each do
        @member = FactoryGirl.create :member, dwolla_auth_token: "TuJ7nsdfsdmmyGksCZAk2OXi1q7btY6wJou71gUMl6IS/0Pcs74si5J"
        sign_in @member
        VCR.use_cassette 'Fund My Account Bad Auth Token' do
          post :create, {amount: 1000000, pin: 1234}
        end
      end
      it "should clear the token from the member account." do
        @member.reload
        @member.dwolla_auth_token.should be_nil
      end
    end

    describe "when requesting too damned much" do
      before :each do
        @member = FactoryGirl.create :member, dwolla_auth_token: "TuJ7nmmyGksCZAk2OXi1q7btY6wJou71gUMl6IS/0Pcs74si5J"
        sign_in @member
      end
      describe "format :js" do
        before(:each) do
          VCR.use_cassette 'Fund My Account Too Much Money' do
            post :create, {amount: 1000000, pin: 1234, pledge_id: 4321, format: :js}
          end
        end
        it "should return HTTP status 403" do
          response.status.should == 403
        end
        it "should have script format" do
          response.content_type.should == "text/javascript"
        end
        it "should render the create.js template" do
          response.should render_template('members/transactions/create')
        end
      end
      it "should not create a new transaction" do
        VCR.use_cassette 'Fund My Account Too Much Money' do
          lambda {
            post :create, {amount: 1000000, pin: 1234}
          }.should_not change(Transaction, :count)
        end
      end
    end
    
    describe "all goes well, format: :js" do
      before(:each) do
        @member = FactoryGirl.create :member, dwolla_auth_token: "TuJ7nmmyGksCZAk2OXi1q7btY6wJou71gUMl6IS/0Pcs74si5J"
        sign_in @member
        VCR.use_cassette 'Fund My Account Success' do
          post :create, {amount: 0.01, pin: 1234, format: :js}
        end
        @transaction = Transaction.where(transaction_id: '1197256').first
      end
      it "should have script format" do
        response.content_type.should == "text/javascript"
      end
      it "should return 200" do
        response.status.should == 200
      end
      it "should render the create.js template" do
        response.should render_template('members/transactions/create')
      end
    end

    describe "specify funding source" do
      before(:each) do
        @member = FactoryGirl.create :member, dwolla_auth_token: "TuJ7nmmyGksCZAk2OXi1q7btY6wJou71gUMl6IS/0Pcs74si5J"
        sign_in @member
        VCR.use_cassette 'Fund My Account Success' do
          post :create, {amount: 0.01, pin: 1234, format: :js}
        end
        @transaction = Transaction.where(transaction_id: '1197256').first
      end
      it "should have script format" do
        response.content_type.should == "text/javascript"
      end
      it "should return 200" do
        response.status.should == 200
      end
      it "should render the create.js template" do
        response.should render_template('members/transactions/create')
      end
    end

    describe 'when all goes well' do
      before :each do
        @member = FactoryGirl.create :member, dwolla_auth_token: "TuJ7nmmyGksCZAk2OXi1q7btY6wJou71gUMl6IS/0Pcs74si5J"
        sign_in @member
        VCR.use_cassette 'Fund My Account Success' do
          post :create, {amount: 0.01, pin: 1234, pledge_id: 1234}
        end
        @transaction = Transaction.where(transaction_id: '1197256').first
      end
      it "should create a new transaction" do
        @transaction.should_not be_nil
      end
      it "should be for the correct amount" do
        @transaction.amount.should == 1
      end
      it "should set the status" do
        @transaction.paid.should be_true
      end
      it "should set the source" do
        @transaction.should be_kind_of(DwollaTransaction)
      end
      it "should redirect to the my_account page" do
        response.should redirect_to(account_path)
      end
      it "should have the correct pledge id" do
        @transaction.pledge_id.should == 1234
      end
    end
  end
end
