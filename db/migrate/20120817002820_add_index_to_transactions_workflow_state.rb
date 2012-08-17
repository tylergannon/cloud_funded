class AddIndexToTransactionsWorkflowState < ActiveRecord::Migration
  def change
    add_index :transactions, :workflow_state
    add_index :pledges, :workflow_state
  end
end
