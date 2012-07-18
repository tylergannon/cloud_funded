require 'spec_helper'

describe Project do
  subject {FactoryGirl.build :project}
  it {should belong_to(:owner)}
  it {should have_many(:pledges)}
  it {should belong_to(:category)}
  # it {should validate_presence_of(:category)}
  it "should have post_to_fb == true" do
    subject.post_to_fb.should be_true
  end
  it {should have_many(:articles)}
  it {should have_attached_file(:image)}
  it {should have_many(:perks)}
  
  describe "callbacks" do
    subject {FactoryGirl.create :project}
    it {should have(3).perks}
  end
  
  describe "#published" do
    it "should be false by default" do
      Project.new.published.should === false
    end
  end
  
  it "should not allow setting published value" do
    expect {
      subject.update_attributes published: true
    }.to raise_error
  end
  
  describe "#start_date" do
    it "should default to today" do
      subject.start_date.should == Date.today
    end
  end
  
  describe "#end_date" do
    it "should be a constant plus the start date" do
      subject.end_date.should == (Date.today + Project::DEFAULT_FUNDRAISE_LENGTH)
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
  
  describe "#financial_goal_string" do
    before :each do
      subject.financial_goal_string = "$100,000"
    end
    it "should set the integer value by stripping non-numeric characters" do
      subject.financial_goal.should == 100000
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
end
