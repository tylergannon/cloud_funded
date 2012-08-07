class RenameStripeTransactionsToTransactions < ActiveRecord::Migration
  def up
    rename_table :stripe_transactions, :transactions
  end

  def down
    rename_table :stripe_transactions, :transactions
  end
end
