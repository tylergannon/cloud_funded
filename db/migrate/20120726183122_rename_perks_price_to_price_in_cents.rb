class RenamePerksPriceToPriceInCents < ActiveRecord::Migration
  def change
    rename_column :projects_perks, :price, :price_cents
    rename_column :pledges, :amount, :amount_cents
    rename_column :transactions, :amount, :amount_cents
    rename_column :transactions, :amount_refunded, :amount_refunded_cents
    rename_column :projects, :financial_goal, :financial_goal_cents
  end
end
