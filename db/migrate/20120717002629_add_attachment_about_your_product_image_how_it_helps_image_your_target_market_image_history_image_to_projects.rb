class AddAttachmentAboutYourProductImageHowItHelpsImageYourTargetMarketImageHistoryImageToProjects < ActiveRecord::Migration
  def self.up
    change_table :projects do |t|
      t.has_attached_file :about_your_product_image
      t.has_attached_file :how_it_helps_image
      t.has_attached_file :your_target_market_image
      t.has_attached_file :history_image
    end
  end

  def self.down
    drop_attached_file :projects, :about_your_product_image
    drop_attached_file :projects, :how_it_helps_image
    drop_attached_file :projects, :your_target_market_image
    drop_attached_file :projects, :history_image
  end
end
