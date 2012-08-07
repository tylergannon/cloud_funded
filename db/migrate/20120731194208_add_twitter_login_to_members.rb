class AddTwitterLoginToMembers < ActiveRecord::Migration
  def change
    add_column :members, :twitter_login_id, :integer
  end
end
