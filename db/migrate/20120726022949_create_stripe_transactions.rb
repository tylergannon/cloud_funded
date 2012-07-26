class CreateStripeTransactions < ActiveRecord::Migration
  def change
    create_table :stripe_transactions do |t|
      t.string :stripe_transaction_id
      t.integer :amount
      t.integer :amount_refunded
      t.datetime :transaction_date
      t.string :description
      t.boolean :disputed
      t.string :failure_message
      t.integer :fee
      t.string :invoice
      t.string :object_type
      t.boolean :paid
      t.boolean :refunded
      t.integer :member_id
      t.integer :pledge_id

      t.timestamps
    end
    add_index :stripe_transactions, :pledge_id
    add_index :stripe_transactions, :member_id
  end
end
