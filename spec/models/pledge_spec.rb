require 'spec_helper'

describe Pledge do
  subject {FactoryGirl.build :pledge}
  it {should belong_to(:project)}
  it {should belong_to(:investor)}
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
