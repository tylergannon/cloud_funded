require 'spec_helper'

describe Member do
  subject {FactoryGirl.build :member}
  it {should have_many(:transactions)}
  it {should have_many(:roles)}
  it {should belong_to(:twitter_login)}
  it {should have_many(:open_graph_actions)}
  it {should have_and_belong_to_many(:administered_projects)}
  
  describe "#normalized_email" do
    it "should be the lowercase version of the email address" do
      subject.email = "NiceBar@CCOOLio.com"
      subject.normalized_email.should == "nicebar@ccoolio.com"
    end
  end
  
  describe "#abilities" do
    subject {Ability.new(@member)}
    before :each do
      @member = FactoryGirl.create :member
      @project = FactoryGirl.create :project
    end
    describe "when I am not an admin" do
      it {should_not be_able_to(:edit, @project)}
    end
    describe "when I have been added as an admin" do
      before :each do
        @project.admins << @member
      end
      it {should be_able_to(:edit, @project)}
    end
  end
  
  describe "#funded?" do
    before :each do
      @member  = FactoryGirl.create :member
      @project = FactoryGirl.create :project
    end
    describe "when I have pledged to a project" do
      describe "when the pledge is paid" do
        before :each do
          FactoryGirl.create :pledge_paid_by_cc, project: @project, investor: @member
          @member.reload
        end
        it "should be true" do
          @member.funded?(@project).should be_true
        end
      end
      describe "when the pledge is not paid" do
        before(:each) do
          FactoryGirl.create :pledge, project: @project, investor: @member
          @member.reload
        end
        it "should be false" do
          @member.funded?(@project).should be_false
        end
      end
    end
    describe "when I have not pledged to a project" do
      it "should be false" do
        @member.funded?(@project).should be_false
      end
    end
  end
  
  describe "#normalized_full_name" do
    it "should be the lowercase version of the full name" do
      subject.full_name = "Tyler Gannon" 
      subject.normalized_full_name.should == "tyler gannon"
    end
  end
  
  describe "#linked_to_dwolla" do
    describe "when there is a dwolla auth token" do
      it "should be false" do
        subject.dwolla_auth_token = nil
        subject.should_not be_linked_to_dwolla
      end
    end
    describe "when there is no dwolla auth token" do
      it "should be true" do
        subject.dwolla_auth_token = "34235wdfasdfasd"
        subject.should be_linked_to_dwolla
      end
    end
  end
  
  describe "#like?" do
    subject {FactoryGirl.create :member}
    before :each do
      @graph_object = FactoryGirl.create :project
      @action = FactoryGirl.create :open_graph_action, graph_object: @graph_object, member: subject
      subject.reload
    end
    it "should like the object" do
      subject.like?(@graph_object).should be_true
    end
    it "should not like some other project" do
      subject.like?(FactoryGirl.create :project).should be_false
    end
  end
  
  describe "full_name" do
    before :each do
      subject.first_name = 'Tyler'
      subject.last_name = 'Gannon'
    end
    it "should be the concatenation of first and last" do
      subject.full_name.should == 'Tyler Gannon'
    end
    it "should be updated when the first name is changed" do
      subject.first_name = 'Mister'
      subject.full_name.should == 'Mister Gannon'
    end
    it "should be updated when the last name is changed" do
      subject.last_name = 'Twister'
      subject.full_name.should == 'Tyler Twister'
    end
  end
  
  
  describe "finds existing team member invitations" do
    before(:each) do
      @role = FactoryGirl.create :projects_role
      @member = FactoryGirl.create :member, email: @role.email_address
      @role.reload
    end
    it "should set the role's member to the newly created member" do
      @role.member.should == @member
    end
  end
  
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
      it {should be_unpaid}
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
