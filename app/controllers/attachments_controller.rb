class AttachmentsController < ApplicationController
  before_filter :load_article
  respond_to :html, :json
  
  # GET /attachments
  # GET /attachments.xml
  def index
    @attachments = @article.attachments
    respond_with(@article, @attachments)
  end

  # GET /attachments/1
  # GET /attachments/1.xml
  def show
    @attachment = @article.attachments.find(params[:id])
    respond_with(@article, @attachment)
  end

  # GET /attachments/new
  # GET /attachments/new.xml
  def new
    @attachment = @article.attachments.build
    respond_with(@article, @attachment)
  end

  # GET /attachments/1/edit
  def edit
    @attachment = @article.attachments.find(params[:id])
  end

  # POST /attachments
  # POST /attachments.xml
  def create
    @attachment = @article.attachments.new(params[:attachment])
    @attachment.save
    respond_with(@article, @attachment) do |format|
      format.html {
        redirect_to edit_admin_article_path(@article)
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
    @attachment = @article.attachments.find(params[:id])
    @attachment.update_attributes(params[:attachment])
    respond_with(@article, @attachment) do |format|
      format.html {
        redirect_to edit_admin_article_path(@article)
      }
    end
  end

  # DELETE /attachments/1
  # DELETE /attachments/1.xml
  def destroy
    @attachment = @article.attachments.find(params[:id])
    @attachment.destroy
    respond_with(@article, @attachment)
  end
  
  def load_article
    @article = Article.find(params[:article_id])
    authorize! :manage, @article
  end
end
