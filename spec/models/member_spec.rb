require 'spec_helper'

describe Member do
  describe "#account_balance" do
    describe "when there are no transactions" do
      before :each do
        @member = FactoryGirl.create :member
      end
      it "should be the sum of the transactions" do
        @member.account_balance.should == 0
      end
    end
    describe "when there are transactions" do
      before :each do
        @member = FactoryGirl.create :member
        FactoryGirl.create :transaction, member: @member, amount: 123.45
        FactoryGirl.create :transaction, member: @member, amount: -112.45
        FactoryGirl.create :transaction, member: @member, amount: 1.45
      end
      it "should be the sum of the transactions" do
        @member.account_balance.should == (123.45 + -112.45 + 1.45)
      end
    end
  end
end
