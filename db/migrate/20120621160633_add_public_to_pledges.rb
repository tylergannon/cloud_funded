class AddPublicToPledges < ActiveRecord::Migration
  def change
    add_column :pledges, :public, :boolean
  end
end
