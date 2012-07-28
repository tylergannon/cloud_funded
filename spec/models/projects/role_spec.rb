require 'spec_helper'

describe Projects::Role do
  subject {FactoryGirl.build :projects_role}
  it {should belong_to(:project)}
  it {should belong_to(:member)}
  it {should validate_presence_of(:project)}
  it {should validate_presence_of(:email_address)}
  it {should validate_presence_of(:name)}
  it {should belong_to(:invited_by)}
  it {should validate_presence_of(:invited_by)}
  
  describe "abilities" do
    before :each do
      @member = FactoryGirl.create(:member)
    end
    subject {Ability.new(@member)}
    it {should be_able_to(:confirm, FactoryGirl.create(:projects_role, member: @member))}
  end

  describe "after create" do
    before :each do
      subject.should_not be_persisted
      subject.confirmation_token.should be_nil
      subject.save!
    end
    it "should generate a confirmation token" do
      subject.confirmation_token.should_not be_nil
    end
    
    it "should send an email to the member being confirmed" do
      ActionMailer::Base.deliveries.last.to.should == [subject.email_address]
    end
    
    it "should have a link to the correct url" do
      ActionMailer::Base.deliveries.last.body.should match subject.confirmation_token
    end
    
    it {should be_unconfirmed}
  end
end
