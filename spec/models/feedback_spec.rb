require 'spec_helper'

describe Feedback do
  subject {FactoryGirl.build(:feedback)}
  
  it {should validate_presence_of(:subject)}
  it {should validate_presence_of(:body)}
  it {should_not allow_value('too short').for(:body)}
  it {should validate_presence_of(:member)}
end
