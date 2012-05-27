class Page < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, use: :slugged
  validates :title, presence: true
  
  has_many :attachments, as: :attachable

  attr_accessible :body, :description, :title
end
