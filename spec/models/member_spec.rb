require 'spec_helper'

describe Member do
  describe "#project_application" do
    before :each do
      @member = FactoryGirl.create :member
    end
    it "should create a project when called for the first time" do
      expect {
        @member.project_application
      }.to change(Project, :count).by(1)
    end
    subject {@member.project_application}
    
    it {should be_kind_of(Project)}
    it {should be_persisted}
    it {should_not be_published}
    
    it "should not create another project after the first time" do
      @member.project_application
      @member = Member.find(@member.to_param)
      expect {
        @member.project_application
      }.to change(Project, :count).by(0)
    end
  end
  
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
