class AddAddressAttributesToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :street_number, :string, limit: 100
    add_column :projects, :route, :string, limit: 200
    add_column :projects, :city, :string, limit: 200
    add_column :projects, :county, :string, limit: 100
    add_column :projects, :state, :string, limit: 2
  end
end
