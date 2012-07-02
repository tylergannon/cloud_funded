class CommentsController < ApplicationController
  respond_to :js
  before_filter :authenticate_member!, only: [:new, :edit, :create, :update, :destroy]
  before_filter :load_article
  
  # GET /comments
  # GET /comments.xml
  def index
    @comments = Comment.all
    respond_with(@comments)
  end

  # GET /comments/1
  # GET /comments/1.xml
  def show
    @comment = @article.comments.find(params[:id])
    respond_with(@comment)
  end

  # GET /comments/new
  # GET /comments/new.xml
  def new
    @comment = @article.comments.new
    authorize! :create, @comment
    respond_with(@comment)
  end

  # GET /comments/1/edit
  def edit
    @comment = @article.comments.find(params[:id])
    authorize! :edit, @comment
  end

  # POST /comments
  # POST /comments.xml
  def create
    @comment = @article.comments.build(params[:comment])
    authorize! :create, @comment
    if verify_recaptcha
      unless @comment.save
        @error = "Error saving comment:\n" +
          @comment.errors.messages.to_a.map{|t| t[0].to_s + ' ' + t[1].join(', ')}.join('\n')
      end
    else
      @error = 'There was a problem with your captcha response.  Please try again.'
    end
    respond_with(@comment) do |format|
      format.js {
        if @error
          render action: 'error'
        else
          render action: 'create'
        end
      }
    end
  end

  # PUT /comments/1
  # PUT /comments/1.xml
  def update
    @comment = @article.comments.find(params[:id])
    authorize! :edit, @comment
    @comment.update_attributes(params[:comment])
    respond_with(@comment)
  end

  # DELETE /comments/1
  # DELETE /comments/1.xml
  def destroy
    @comment = @article.comments.find(params[:id])
    authorize! :destroy, @comment
    @comment.destroy
    respond_with(@comment)
  end
  
  def load_article
    @article = Article.find(params[:article_id])
  end
end
