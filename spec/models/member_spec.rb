require 'spec_helper'

describe Member do
  subject {FactoryGirl.build :member}
  it {should have_many(:stripe_transactions)}
  describe "#pledge_for" do
    before :each do
      @project = FactoryGirl.create :project
      @member = FactoryGirl.create :member
    end
    describe "when I am just starting to pledge to the project" do
      subject {@member.pledge_for(@project)}
      it "should create a new pledge" do
        expect {
          subject
        }.to change(Pledge, :count).by(1)
      end
      it {should be_not_pledged}
    end
    describe "when I have already pledged to the project" do
      subject {@member.pledge_for(@project)}
      before(:each) do
        @pledge = subject
      end
      it {should be == @pledge}
      it "should not create a new pledge object" do
        expect {
          @member.pledge_for(@project)
        }.to change(Pledge, :count).by(0)
      end
    end
  end
  
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
        FactoryGirl.create :transaction, member: @member, amount: 12345
        FactoryGirl.create :transaction, member: @member, amount: -11245
        FactoryGirl.create :transaction, member: @member, amount: 145
      end
      it "should be the sum of the transactions" do
        @member.account_balance.should == (12345 + -11245 + 145)
      end
    end
  end
end
