class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :body
      t.integer :member_id
      t.integer :article_id

      t.timestamps
    end
  end
end
