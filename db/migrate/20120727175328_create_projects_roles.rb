class CreateProjectsRoles < ActiveRecord::Migration
  def change
    create_table :projects_roles do |t|
      t.string :name, limit: 200
      t.integer :project_id
      t.integer :member_id
      t.integer :invited_by_id
      t.string :email_address, limit: 200
      t.string :workflow_state, limit: 100
      t.integer :ordinal
      t.string :confirmation_token, limit: 100
      t.string :tagline, limit: 300
      t.timestamps
    end
    
    add_index :projects_roles, :project_id
    add_index :projects_roles, :member_id
  end
end
