class AddTypeToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :type, :string, limit: 30
    add_index :transactions, [:id, :type]
    rename_column :transactions, :stripe_transaction_id, :transaction_id
  end
end
