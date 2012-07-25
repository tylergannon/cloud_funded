class AddSourceToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :source, :string
  end
end
