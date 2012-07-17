class CreatePerks < ActiveRecord::Migration
  def change
    create_table :perks do |t|
      t.integer :project_id
      t.string :name
      t.string :description, limit: 8000
      t.integer :price
      t.integer :quantity
      t.string :delivery_terms

      t.timestamps
    end
    add_index :perks, :project_id
  end
end
