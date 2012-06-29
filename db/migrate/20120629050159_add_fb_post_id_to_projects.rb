class AddFbPostIdToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :fb_post_id, :string
  end
end
