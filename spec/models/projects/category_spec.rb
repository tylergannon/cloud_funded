require 'spec_helper'

describe Projects::Category do
  subject {FactoryGirl.create :projects_category}
  it {should validate_presence_of(:name)}
  it {should have_many(:projects)}
end
