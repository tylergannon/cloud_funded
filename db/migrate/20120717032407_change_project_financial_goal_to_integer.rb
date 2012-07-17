class ChangeProjectFinancialGoalToInteger < ActiveRecord::Migration
  def up
    change_column :projects, :financial_goal, :integer
  end

  def down
    change_column :projects, :financial_goal, :decimal
  end
end
