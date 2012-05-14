class Pledge < ActiveRecord::Base
  attr_accessible :amount, :investor, :project
  belongs_to :investor, class_name: 'Member'
  belongs_to :project
end
