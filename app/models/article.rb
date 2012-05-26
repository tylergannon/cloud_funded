class Article < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, use: :slugged
  
  attr_accessible :body, :published_at, :title, :published
  
  belongs_to :author, class_name: 'Member'
  has_many :attachments, as: :attachable
  
  default_scope order('published_at desc')
  
  def published=(pub)
    if !self.published && pub==true
      self.published_at = Time.zone.now
    end
  end
end
