# This migration comes from mercury_engine (originally 20110526035601)
class CreateMercuryImages < ActiveRecord::Migration
  def change
    create_table :mercury_images do |t|
      t.string :image_file_name
      t.string :image_content_type
      t.integer :image_file_size
      t.datetime :image_updated_at
      t.timestamps
    end
  end
end
