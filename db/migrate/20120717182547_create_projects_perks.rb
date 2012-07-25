class CreateProjectsPerks < ActiveRecord::Migration
  def change
    create_table :projects_perks do |t|
      t.integer :project_id
      t.string :name
      t.string :description, limit: 8000
      t.string :slug
      t.integer :price
      t.integer :quantity
      t.string :delivery_terms
      t.has_attached_file :image
      t.timestamps
    end
    add_index :projects_perks, :project_id
    add_index :projects_perks, [:id, :project_id]
  end
end
