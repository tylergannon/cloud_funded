class CreateFeedbacks < ActiveRecord::Migration
  def change
    create_table :feedbacks do |t|
      t.string :subject
      t.text :body
      t.integer :member_id
      t.string :about_page

      t.timestamps
    end
  end
end
