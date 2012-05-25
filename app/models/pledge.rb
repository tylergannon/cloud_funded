class Pledge < ActiveRecord::Base
  attr_accessible :amount, :investor, :project
  belongs_to :investor, class_name: 'Member'
  belongs_to :project
  
  validates :investor, presence: true
  validates :project, presence: true
end
