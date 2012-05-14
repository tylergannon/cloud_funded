class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.text :description
      t.decimal :financial_goal
      t.integer :owner_id
      t.string :slug
      t.datetime :completion_date

      t.timestamps
    end
    
    add_index :projects, :slug, unique: true
  end
end
