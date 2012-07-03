class AddUrlsToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :google_places, :string
    add_column :projects, :facebook, :string
    add_column :projects, :linkedin_profile, :string
    add_column :projects, :linkedin_business, :string
    add_column :projects, :yelp, :string
    add_column :projects, :google_plus, :string
  end
end
