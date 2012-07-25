class Projects::Category < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged
  
  attr_accessible :desription, :name
  validates_presence_of :name
  has_many :projects
end
