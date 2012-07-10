class AddProjectCategories < ActiveRecord::Migration
  def up
    Projects::Category.create! name: 'Store / Retail'
    Projects::Category.create! name: 'Restaurant'
    Projects::Category.create! name: 'Store / Grocery'
    Projects::Category.create! name: 'Non-Profit'
    Projects::Category.create! name: 'Education'
    Projects::Category.create! name: 'Tech / Sustainability'
    Projects::Category.create! name: 'Tech / Internet'
    Projects::Category.create! name: 'Art / Entertainment'
  end

  def down
    Projects::Category.destroy_all
  end
end
