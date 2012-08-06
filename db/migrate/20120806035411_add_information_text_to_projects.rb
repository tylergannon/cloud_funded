class AddInformationTextToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :information_text, :string, limit: 65534
  end
end
