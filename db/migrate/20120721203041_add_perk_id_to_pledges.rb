class AddPerkIdToPledges < ActiveRecord::Migration
  def change
    add_column :pledges, :perk_id, :integer
  end
end
