class CreateProjectsCategories < ActiveRecord::Migration
  def change
    create_table :projects_categories do |t|
      t.string :name
      t.string :desription

      t.timestamps
    end
  end
end
