class AddGooglePlusToMembers < ActiveRecord::Migration
  def change
    add_column :members, :google_plus, :string
  end
end
