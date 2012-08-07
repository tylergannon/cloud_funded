class AddSortOrderToProjectsPerks < ActiveRecord::Migration
  def change
    add_column :projects_perks, :sort_order, :integer
  end
end
