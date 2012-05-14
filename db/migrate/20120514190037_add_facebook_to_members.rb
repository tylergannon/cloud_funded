class AddFacebookToMembers < ActiveRecord::Migration
  def change
    add_column :members, :facebook_id, :integer
    add_column :members, :profile_pic, :string
    
    add_index :members, :facebook_id, unique: true
  end
end
