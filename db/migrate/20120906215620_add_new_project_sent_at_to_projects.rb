class AddNewProjectSentAtToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :new_project_sent_at, :datetime
  end
end
