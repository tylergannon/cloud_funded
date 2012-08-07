class CreateMembersOmniauthLogins < ActiveRecord::Migration
  def change
    create_table :members_omniauth_logins do |t|
      t.string :type, limit: 50
      t.string :token, limit: 100
      t.string :user_id, limit: 100
      t.string :nickname, limit: 255
      t.string :profile_url, limit: 1000
      t.string :profile_pic, limit: 1000
      t.string :name, limit: 255
      t.string :location, limit: 255
      t.string :email, limit: 255
      t.integer :member_id
      t.timestamps
    end
    add_index :members_omniauth_logins, :member_id
    add_index :members_omniauth_logins, :user_id
  end
end
