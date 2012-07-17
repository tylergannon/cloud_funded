require 'spec_helper'

describe Perk do
  subject {FactoryGirl.create :perk}
  it {should belong_to(:project)}
end
