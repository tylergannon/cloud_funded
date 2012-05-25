class Article < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, use: :slugged
  
  attr_accessible :body, :published_at, :title, :published
  
  belongs_to :author, class_name: 'Member'
end
