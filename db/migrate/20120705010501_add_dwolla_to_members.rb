class AddDwollaToMembers < ActiveRecord::Migration
  def change
    add_column :members, :dwolla_id, :string
    add_column :members, :dwolla_auth_token, :string
  end
end
