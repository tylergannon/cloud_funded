class Feedback < ActiveRecord::Base
  attr_accessible :about_page, :body, :member_id, :subject, :member
  belongs_to :member

  validates :member, presence: true
  validates :subject, presence: true
  validates :body, presence: true, length: {minimum: 20}
end
