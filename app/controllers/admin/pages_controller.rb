class Admin::PagesController < ApplicationController
  respond_to :json, :html
  before_filter :authenticate_admin
  
  def authenticate_admin
    authorize! :manage, Page
  end
  
  def index
    @pages = Page.all
    respond_with(@pages)
  end

  # GET /pages/1
  # GET /pages/1.xml
  def show
    @page = Page.find(params[:id])
    respond_with(@page)
  end

  # GET /pages/new
  # GET /pages/new.xml
  def new
    @page = Page.new
    respond_with(@page)
  end

  # GET /pages/1/edit
  def edit
    @page = Page.find(params[:id])
  end

  def mercury_update
    page = Page.find(params[:id])
    
    page.update_attributes title: params[:content][:page_title][:value], 
                              body: params[:content][:page_body][:value],
                              description: params[:content][:page_description][:value]
    
    # Update page
    render text: ""
  end


  # POST /pages
  # POST /pages.xml
  def create
    @page = Page.new(params[:page])
    @page.save
    respond_with(@page) do |format|
      format.html {
        redirect_to '/editor' + admin_page_path(@page)
      }
    end
  end

  # PUT /pages/1
  # PUT /pages/1.xml
  def update
    @page = Page.find(params[:id])
    @page.update_attributes(params[:page])
    respond_with(@page) do |format|
      format.html {
        redirect_to edit_admin_page_path(@page)
      }
    end
  end

  # DELETE /pages/1
  # DELETE /pages/1.xml
  def destroy
    @page = Page.find(params[:id])
    @page.destroy
    respond_with(@page)
  end
end
