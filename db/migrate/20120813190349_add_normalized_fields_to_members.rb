class AddNormalizedFieldsToMembers < ActiveRecord::Migration
  def up
    add_column :members, :normalized_email, :string
    add_column :members, :normalized_full_name, :string
    Member.all.each do |member|
      member.email = member.email
      member.full_name = member.full_name
      member.save
    end
  end
  
  def down
    remove_column :members, :normalized_email
    remove_column :members, :normalized_full_name
  end
end
