class Comment < ActiveRecord::Base
  attr_accessible :body, :member, :member_id, :article_id
  belongs_to :article
  belongs_to :member
  
  validates :member, presence: true
  validates :article, presence: true
  validates :body, presence: true, length: {minimum: 10}
end
