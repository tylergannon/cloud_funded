class AddSlugToMembers < ActiveRecord::Migration
  def change
    add_column :members, :slug, :string
  end
end
