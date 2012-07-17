class AddAttachmentImageToPerks < ActiveRecord::Migration
  def self.up
    change_table :perks do |t|
      t.has_attached_file :image
    end
  end

  def self.down
    drop_attached_file :perks, :image
  end
end
