class ChangePledgeAmountToInteger < ActiveRecord::Migration
  def up
    change_column :pledges, :amount, :integer
  end

  def down
    change_column :pledges, :amount, :decimal
  end
end
