class AddWorkflowStateToPledges < ActiveRecord::Migration
  def change
    add_column :pledges, :workflow_state, :string
  end
end
