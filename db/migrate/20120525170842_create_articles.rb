class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :title
      t.text :body
      t.datetime :published_at
      t.string :slug
      t.integer :member_id
      t.timestamps
    end
    add_index :articles, :slug, unique: true
  end
end
