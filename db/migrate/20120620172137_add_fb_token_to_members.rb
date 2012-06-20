class AddFbTokenToMembers < ActiveRecord::Migration
  def change
    add_column :members, :fb_token, :string
  end
end
