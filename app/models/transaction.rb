class Transaction < ActiveRecord::Base
  attr_accessible :amount, :member_id, :transaction_id, :member, :source, :status
  belongs_to :member
  belongs_to :project
  
  validates :member, presence: true
  validates :source, presence: true
  validates :status, presence: true
  validates :amount, presence: true, numericality: true
end
