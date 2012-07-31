require 'spec_helper'

describe Members::TwitterLogin do
  subject {FactoryGirl.create :twitter_login}
  it {should have_one(:member)}
end
