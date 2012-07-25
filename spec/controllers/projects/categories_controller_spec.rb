require 'spec_helper'

describe Projects::CategoriesController do
  render_views
  def valid_attributes
    {name: "Businesses"}
  end
  
  describe "GET index" do
    it "assigns all projects_categories as @projects_categories" do
      category = Projects::Category.create! valid_attributes
      get :index, {}
      assigns(:categories).should eq([category])
    end
  end

  describe "GET show" do
    it "assigns the requested projects_category as @projects_category" do
      category = Projects::Category.create! valid_attributes
      get :show, {:id => category.to_param}
      assigns(:category).should eq(category)
    end
  end

end
