class ChangeLengthOfShortDescription < ActiveRecord::Migration
  def up
    change_column :projects, :short_description, :string, limit: 65534
  end

  def down
    change_column :projects, :short_description, :string, limit: 256
  end
end
