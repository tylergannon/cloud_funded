class AddSortOrderToProjectsRoles < ActiveRecord::Migration
  def change
    add_column :projects_roles, :sort_order, :integer
  end
end
