class ChangeMembersFbIdToString < ActiveRecord::Migration
  def up
    change_column :members, :facebook_id, :string
  end

  def down
    change_column :members, :facebook_id, :integer
  end
end
