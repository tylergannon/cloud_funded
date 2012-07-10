class Projects::CategoriesController < ApplicationController
  def index
    @categories = Projects::Category.all
    respond_with @categories
  end
  
  def show
    @category = Projects::Category.find(params[:id])
    respond_with @category
  end
end
