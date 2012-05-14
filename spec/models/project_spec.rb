require 'spec_helper'

describe Project do
  subject {Factory :project}
  it {should belong_to(:owner)}
  it {should have_many(:pledges)}
end
