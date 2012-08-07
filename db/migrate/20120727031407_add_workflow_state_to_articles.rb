class AddWorkflowStateToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :workflow_state, :string, limit: 20
  end
end
