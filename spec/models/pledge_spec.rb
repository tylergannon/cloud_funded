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
