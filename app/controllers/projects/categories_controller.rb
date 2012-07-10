class Projects::CategoriesController < ApplicationController
  # GET /projects_categories
  # GET /projects_categories.xml
  def index
    @projects_categories = Projects::Category.all
    respond_with(@projects_categories)
  end

  # GET /projects_categories/1
  # GET /projects_categories/1.xml
  def show
    @category = Projects::Category.find(params[:id])
    respond_with(@category)
  end

  # GET /projects_categories/new
  # GET /projects_categories/new.xml
  def new
    @category = Projects::Category.new
    respond_with(@category)
  end

  # GET /projects_categories/1/edit
  def edit
    @category = Projects::Category.find(params[:id])
  end

  # POST /projects_categories
  # POST /projects_categories.xml
  def create
    @category = Projects::Category.new(params[:category])
    @projects_category.save
    respond_with(@category)
  end

  # PUT /projects_categories/1
  # PUT /projects_categories/1.xml
  def update
    @category = Projects::Category.find(params[:id])
    @projects_category.update_attributes(params[:category])
    respond_with(@category)
  end

  # DELETE /projects_categories/1
  # DELETE /projects_categories/1.xml
  def destroy
    @category = Projects::Category.find(params[:id])
    @projects_category.destroy
    respond_with(@category)
  end
end
