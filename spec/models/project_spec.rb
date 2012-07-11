require 'spec_helper'

describe Project do
  subject {FactoryGirl.build :project}
  it {should belong_to(:owner)}
  it {should have_many(:pledges)}
  it {should belong_to(:category)}
  it {should validate_presence_of(:category)}
  it "should have post_to_fb == true" do
    subject.post_to_fb.should be_true
  end
  it {should have_many(:articles)}
end
