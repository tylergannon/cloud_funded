require 'spec_helper'

class MyThingTest
  def setup
    #  do stuff
  end
end

describe Project do
  subject {FactoryGirl.build :project}
  it {should belong_to(:owner)}
  it {should have_many(:pledges)}
  it {should belong_to(:category)}
  it {should have_many(:roles)}
  it {should have_and_belong_to_many(:admins)}
  # it {should validate_presence_of(:category)}
  it "should have post_to_fb == true" do
    subject.post_to_fb.should be_true
  end
  it {should have_many(:articles)}
  it {should have_attached_file(:image)}
  it {should have_many(:perks)}
  it {should validate_presence_of(:start_date)}
  it {should validate_presence_of(:end_date)}
  it {should have_many(:attachments)}
  
  describe "when the project goes to the previewing state" do
    before :each do
      subject.preview!
    end
    it {should validate_presence_of(:tagline)}
  end
  
  describe "callbacks" do
    subject {FactoryGirl.create :project}
    it {should have(3).perks}
  end
  
  describe "#workflow" do
    it "should start out new" do
      Project.new.should be_new
    end

    it "should not allow setting workflow_state value" do
      expect {
        subject.update_attributes workflow_state: :live
      }.to raise_error
    end
    
    describe "when going live" do
      before :each do
        @project = FactoryGirl.create :live_project, workflow_state: 'being_reviewed'
      end
      it "should create a launch action" do
        
        OpenGraph::Launch.should_receive(:create).with( {
          member: @project.owner,
          graph_object: @project}).and_return true
        @project.accept!
        
      end
    end
  end
  
  describe "#start_date" do
    it "should default to today" do
      subject.start_date.should == Date.today
    end
    it "should accept mm/dd/yyyy format" do
      subject.start_date = "07/19/2012"
      subject.start_date.should == Date.parse("2012-07-19")
    end
  end
  
  describe "#end_date" do
    it "should be a constant plus the start date" do
      subject.end_date.should == (Date.today + Project::DEFAULT_FUNDRAISE_LENGTH)
    end
    it "should accept mm/dd/yyyy format" do
      subject.end_date = "07/19/2012" 
      subject.end_date.should == Date.parse("2012-07-19")
    end
  end
  
  describe "#days" do
    before :each do
      subject.start_date = Date.today - 100
      subject.end_date = Date.today
    end
    it "should give the number of days between start and end date" do
      subject.days.should == 100
    end
  end
  
  describe "#pledges.paid" do
    before :each do
      FactoryGirl.create :pledge, project: subject
      @pledge = FactoryGirl.create :pledge_paid_by_cc, project: subject
      subject.reload
    end
    it "should have one completed pledge" do
      subject.pledges.paid.should == [@pledge]
    end
  end
  
  describe "#financial_goal_string" do
    before :each do
      subject.financial_goal_string = "$100,000"
    end
    it "should set the integer value by stripping non-numeric characters" do
      subject.financial_goal.should == Money.us_dollar(100000 * 100)
    end
    it "should return the value with delimiter" do
      subject.financial_goal_string.should == '100,000'
    end
  end
  
  describe '#as_json' do
    [:image, :about_your_product_image, :how_it_helps_image, :your_target_market_image, 
    :history_image].each do |image|
      it "should have the #{image} path" do
        subject.as_json[image][:url_original].should == "/#{image.to_s.tableize}/original/missing.png"
        subject.as_json[image][:url_large].should == "/#{image.to_s.tableize}/large/missing.png"
      end
    end
  end
  
  describe "abilities" do
    before :each do
      @member = FactoryGirl.create(:member)
    end
    subject {Ability.new(@member)}
    describe "when I own the project" do
      it {should be_able_to(:read,FactoryGirl.create( :project, owner: @member))}
      it {should be_able_to(:edit,FactoryGirl.create( :project, owner: @member))}
      # it {should be_able_to(:destroy,FactoryGirl.create( :project, owner: @member))}
    end

    describe "when I do not own the project" do
      it {should be_able_to(:read,FactoryGirl.create( :live_project, workflow_state: :live))}
      it {should_not be_able_to(:read,FactoryGirl.create( :project))}
      it {should_not be_able_to(:edit,FactoryGirl.create( :project))}
      it {should_not be_able_to(:destroy,FactoryGirl.create( :project))}
    end
  end
end
