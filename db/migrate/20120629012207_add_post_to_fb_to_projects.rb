class AddPostToFbToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :post_to_fb, :boolean
  end
end
