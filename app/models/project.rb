class Project < ActiveRecord::Base
  attr_accessible :description, :financial_goal, :name
end
