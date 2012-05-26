require 'spec_helper'

describe Article do
  subject {FactoryGirl.create(:article)}
  
  it "should reset the published at time when published." do
    subject.should_receive(:published_at=)
    subject.update_attributes(published: true)
  end
end
