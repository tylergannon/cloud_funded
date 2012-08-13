class CreateProjectsAdmins < ActiveRecord::Migration
  def change
    create_table :projects_admins, id: false do |t|
      t.integer :project_id
      t.integer :member_id
    end
    add_index :projects_admins, :project_id
    add_index :projects_admins, :member_id
  end
end
