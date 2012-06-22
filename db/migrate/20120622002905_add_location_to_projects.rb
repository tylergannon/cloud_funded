class AddLocationToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :address, :string
    add_column :projects, :lat, :float
    add_column :projects, :long, :float
  end
end
