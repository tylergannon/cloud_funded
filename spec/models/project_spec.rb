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
  
  describe '#as_json' do
    it "should have the image path" do
      subject.as_json[:image][:url_original].should == '/images/original/missing.png'
      subject.as_json[:image][:url_large].should == '/images/original/missing.png'
    end
  end
end
