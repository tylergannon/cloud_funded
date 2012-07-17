class Perk < ActiveRecord::Base
  attr_accessible :delivery_terms, :description, :name, :price, :quantity
  belongs_to :project
end
