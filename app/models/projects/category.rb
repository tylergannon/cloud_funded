class Projects::Category < ActiveRecord::Base
  attr_accessible :desription, :name
  validates_presence_of :name
  has_many :projects
end
