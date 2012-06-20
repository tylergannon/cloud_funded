class Page < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, use: :slugged
  validates :title, presence: true
  
  has_many :attachments, as: :attachable
  def slug=(sl)
    super(sl.parameterize)
  end

  attr_accessible :body, :description, :title, :slug
  def should_generate_new_friendly_id?
    new_record?
  end
end
