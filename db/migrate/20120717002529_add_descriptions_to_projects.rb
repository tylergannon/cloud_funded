class AddDescriptionsToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :about_your_product, :string, limit: 65534
    add_column :projects, :how_it_helps, :string, limit: 65534
    add_column :projects, :your_target_market, :string, limit: 65534
    add_column :projects, :history, :string, limit: 65534
  end
end
