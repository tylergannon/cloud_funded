class AddPrivacyOptionsToPledges < ActiveRecord::Migration
  def change
    add_column :pledges, :post_to_fb, :boolean
    rename_column :pledges, :public, :public_amount
    add_column :pledges, :public_viewable, :boolean
  end
end
