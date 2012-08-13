class CreateMembersUpdatesUpdates < ActiveRecord::Migration
  def change
    create_table :members_updates_updates do |t|
      t.string :type
      t.boolean :read
      t.integer :member_id
      t.integer :object1_id
      t.string :object1_type
      t.integer :object2_id
      t.string :object2_type
      t.timestamps
    end
    
    add_index :members_updates_updates, [:member_id, :read]
  end
end
