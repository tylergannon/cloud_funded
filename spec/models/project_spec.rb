require 'spec_helper'

describe Project do
  subject {FactoryGirl.create :project}
  it {should belong_to(:owner)}
  it {should have_many(:pledges)}
end
