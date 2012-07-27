class Article < ActiveRecord::Base
  include Workflow
  extend FriendlyId
  friendly_id :title, use: :slugged
  
  attr_accessible :body, :published_at, :title, :published, :description
  
  belongs_to :author, class_name: 'Member'
  has_many :attachments, as: :attachable
  has_many :comments
  belongs_to :project
  
  validates :author, presence: true
  default_scope order('published_at desc')

  workflow do
    state :unpublished do
      event :publish, transitions_to: :published
    end
    
    state :published
  end
  
  def publish
    self.published_at = Time.zone.now
  end
end
