class AddFbPostIdToPledges < ActiveRecord::Migration
  def change
    add_column :pledges, :fb_post_id, :string
  end
end
