require 'spec_helper'

describe Transaction do
  subject {FactoryGirl.create :transaction}
  it {should validate_presence_of(:amount)}
  it {should validate_presence_of(:source)}
  it {should validate_presence_of(:status)}
  it {should validate_presence_of(:member)}
  it {should validate_numericality_of(:amount)}
end
