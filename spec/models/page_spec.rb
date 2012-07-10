require 'spec_helper'

describe Page do
  subject {FactoryGirl.build(:page)}
  it {should validate_presence_of(:title)}
  it {should validate_presence_of(:description)}
  it {should have_many(:attachments)}
end
