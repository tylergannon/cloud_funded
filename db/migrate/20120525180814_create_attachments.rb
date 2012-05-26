class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.string :title
      t.string :attachable_type
      t.integer :attachable_id

      t.timestamps
    end
  end
end
