require 'spec_helper'

describe Comment do
  subject {FactoryGirl.create :comment}
  it {should validate_presence_of(:member)}
  it {should validate_presence_of(:article)}
  it {should validate_presence_of(:body)}
  it {should_not allow_value('short').for(:body)}
end

  # belongs_to :article
  # belongs_to :member
  # 
  # validates :body, presence: true, length: {minimum: 10}
