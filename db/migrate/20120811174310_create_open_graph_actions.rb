class CreateOpenGraphActions < ActiveRecord::Migration
  def change
    create_table :open_graph_actions do |t|
      t.integer :member_id
      t.string :action_id
      t.string :type
      t.string :graph_object_type
      t.integer :graph_object_id

      t.timestamps
    end
    add_index :open_graph_actions, [:graph_object_type, :graph_object_id], name: :idx_open_graph_graph_object
    add_index :open_graph_actions, :action_id
    add_index :open_graph_actions, :member_id
  end
end
