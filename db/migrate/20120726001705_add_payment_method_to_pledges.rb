class AddPaymentMethodToPledges < ActiveRecord::Migration
  def change
    add_column :pledges, :payment_method, :string, limit: 10
  end
end
