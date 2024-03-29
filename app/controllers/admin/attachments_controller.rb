class Admin::AttachmentsController < ApplicationController
  before_filter :authenticate_member!
  before_filter :load_parent
  respond_to :html, :json
  
  # GET /attachments
  # GET /attachments.xml
  def index
    @attachments = @parent.attachments
    respond_with(@parent, @attachments)
  end

  # GET /attachments/1
  # GET /attachments/1.xml
  def show
    @attachment = @parent.attachments.find(params[:id])
    respond_with(@parent, @attachment)
  end

  # GET /attachments/new
  # GET /attachments/new.xml
  def new
    @attachment = @parent.attachments.build
    respond_with(@parent, @attachment)
  end

  # GET /attachments/1/edit
  def edit
    @attachment = @parent.attachments.find(params[:id])
  end

  # POST /attachments
  # POST /attachments.xml
  def create
    @attachment = @parent.attachments.new(params[:attachment])
    @attachment.save!
    respond_with(@parent, @attachment) do |format|
      format.html {
        redirect_to polymorphic_path([:admin, @parent, :attachments])
      }
      format.json {
        render json: {
          image: {
            url: @attachment.image.url
          }
        }
      }
    end
  end

  # PUT /attachments/1
  # PUT /attachments/1.xml
  def update
    @attachment = @parent.attachments.find(params[:id])
    @attachment.update_attributes(params[:attachment])
    respond_with(@parent, @attachment) do |format|
      format.html {
        redirect_to polymorphic_path([:admin, @parent, :attachments])
      }
    end
  end

  # DELETE /attachments/1
  # DELETE /attachments/1.xml
  def destroy
    @attachment = @parent.attachments.find(params[:id])
    @attachment.destroy
    respond_with(@parent, @attachment)
  end
  
  def load_parent
    if params[:article_id]
      @article = @parent = Article.find(params[:article_id])
    elsif params[:page_id]
      @page = @parent = Page.find(params[:page_id])
    elsif params[:project_id]
      @project = @parent = Project.find(params[:project_id])
    end
    authorize! :edit, @parent
  end
end
