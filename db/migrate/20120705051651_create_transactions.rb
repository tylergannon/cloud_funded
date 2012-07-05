class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.integer :member_id
      t.decimal :amount
      t.string :transaction_id

      t.timestamps
    end
    
    add_index :transactions, :member_id
  end
end
