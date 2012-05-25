class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :title
      t.text :body
      t.datetime :published_at
      t.string :slug
      t.integer :author_id
      t.boolean :published
      t.timestamps
    end
    add_index :articles, :slug, unique: true
  end
end
