class Admin::Projects::CategoriesController < ApplicationController
  before_filter :authenticate_admin
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
    @category.save
    respond_with(@category) do |format|
      format.html {
        if @category.persisted?
          redirect_to admin_projects_categories_path
        else
          render action: :new
        end
      }
    end
  end

  # PUT /projects_categories/1
  # PUT /projects_categories/1.xml
  def update
    @category = Projects::Category.find(params[:id])
    @category.update_attributes(params[:category])
    respond_with(@category) do |format|
      format.html {
        if @category.valid?
          redirect_to admin_projects_categories_path
        else
          render action: :edit
        end
      }
    end
  end

  # DELETE /projects_categories/1
  # DELETE /projects_categories/1.xml
  def destroy
    @category = Projects::Category.find(params[:id])
    @category.destroy
    respond_with(@category) do |format|
      format.html {
        redirect_to admin_projects_categories_path
      }
    end
  end
end
