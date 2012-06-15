class AddIndexesToPledges < ActiveRecord::Migration
  def up
    add_index :pledges, [:project_id, :investor_id], name: :idx_pledges_project_investor
    add_index :pledges, :project_id, name: :idx_pledges_project
  end
  
  def down
    remove_index :pledges, name: :idx_pledges_project_investor
    remove_index :pledges, name: :idx_pledges_project
  end
end
