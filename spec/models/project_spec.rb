require 'spec_helper'

describe Project do
  subject {FactoryGirl.build :project}
  it {should belong_to(:owner)}
  it {should have_many(:pledges)}
  it "should have post_to_fb == true" do
    subject.post_to_fb.should be_true
  end
  
end
