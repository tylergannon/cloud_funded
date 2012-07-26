require 'spec_helper'

describe Pledge do
  before :each do
    Project.any_instance.stub(:save_attached_files).and_return(true)
    Project.any_instance.stub(:destroy_attached_files).and_return(true)
    Paperclip::Attachment.any_instance.stub(:queue_all_for_delete).and_return(true)
  end
  subject {FactoryGirl.build :pledge}
  it {should belong_to(:project)}
  it {should belong_to(:investor)}
  
  describe "when the pledge is not new" do
    subject {FactoryGirl.create :pledge_choose_payment_method}
    it {should validate_presence_of(:perk)}
  end
  
  it {should belong_to(:perk)}
  it {should have_many(:stripe_transactions)}
  
  describe "when the latest transaction was a failed payment attempt" do
    subject {
      subj = FactoryGirl.create :pledge_pay_by_cc
      subj.stripe_transactions << FactoryGirl.create( :stripe_transaction, paid: false)
      subj
    }
    it {should_not be_valid}
  end
  
  describe "#latest_transaction" do
    it "should give the most recent stripe transaction" do
      pledge = FactoryGirl.create :pledge
      pledge.stripe_transactions << FactoryGirl.create(:stripe_transaction, pledge: pledge)
      pledge.stripe_transactions << transaction = FactoryGirl.create(:stripe_transaction, pledge: pledge)
      pledge.latest_transaction.should == transaction
    end
    describe "when there are no transactions" do
      it "should be nil" do
        pledge = FactoryGirl.create :pledge
        pledge.stripe_transactions.should be_empty
        pledge.latest_transaction.should be_nil
      end
    end
  end
  
  describe "#validations" do
    describe "when the pledge amount is less than the perk" do
      before(:each){subject.perk.price = (subject.amount + 1)}
      it {should_not be_valid}
    end
    describe "when the pledge amount is >= the perk price" do
      before(:each){subject.perk.price = (subject.amount - 1)}
      it {should be_valid}
    end
  end
  
  describe "abilities" do
    before :each do
      @member = FactoryGirl.create(:member)
    end
    subject {Ability.new(@member)}
    describe "when I own the project" do
      it {should be_able_to(:read,FactoryGirl.create( :pledge, project: FactoryGirl.create(:project)))}
    end

    describe "when it is my pledge" do
      it {should be_able_to(:manage ,FactoryGirl.create( :pledge, investor: @member))}
    end
  end
    
  it "should have post_to_fb == true" do
    subject.post_to_fb.should be_true
  end
  it "should have public amount true" do
    subject.public_amount.should be_true
  end
  it "should have public viewable true" do
    subject.public_viewable.should be_true
  end
end
