class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.integer :member_id
      t.decimal :amount
      t.string :transaction_id
      t.string :status
      t.integer :project_id

      t.timestamps
    end
    
    add_index :transactions, :member_id
    add_index :transactions, :project_id
  end
end
