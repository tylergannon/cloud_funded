class AddProjectIdToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :project_id, :integer
    add_index :articles, :project_id
  end
end
