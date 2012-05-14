class CreatePledges < ActiveRecord::Migration
  def change
    create_table :pledges do |t|
      t.decimal :amount
      t.integer :project_id
      t.integer :investor_id
      t.timestamps
    end
  end
end
