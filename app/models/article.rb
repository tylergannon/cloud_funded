class Article < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, use: :slugged
  
  attr_accessible :body, :published_at, :title, :published, :description
  
  belongs_to :author, class_name: 'Member'
  has_many :attachments, as: :attachable
  has_many :comments
  belongs_to :project
  
  validates :author, presence: true
  default_scope order('published_at desc')
  
  def published=(pub)
    self.published_at = Time.zone.now
    super
  end
end
