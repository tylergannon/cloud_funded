class Project < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged
  
  attr_accessible :description, :financial_goal, :name, :owner, :pledges, :completion_date
  
  belongs_to :owner, class_name: 'Member'
  has_many :pledges
end
