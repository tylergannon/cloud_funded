class AddCategoryIdToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :category_id, :integer
    add_index :projects, :category_id
  end
end
