class AddSlugToProjectsCategories < ActiveRecord::Migration
  def change
    add_column :projects_categories, :slug, :string
  end
end
