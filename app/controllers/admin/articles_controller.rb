class Admin::ArticlesController < ApplicationController
  before_filter :authenticate_member!
  
  def index
    @articles = Article.all
    respond_with(@articles) do |format|
      format.html {
        render layout: 'admin'
      }
    end
  end

  # GET /articles/1
  # GET /articles/1.xml
  def show
    @article = Article.find(params[:id])
    authorize! :read, @article
    respond_with(@article)
  end

  # GET /articles/new
  # GET /articles/new.xml
  def new
    @article = Article.new
    authorize! :create, @article
    respond_with(@article)
  end

  # GET /articles/1/edit
  def edit
    @article = Article.find(params[:id])
    authorize! :edit, @article
  end
  
  def mercury_update
    article = Article.find(params[:id])
    
    article.update_attributes title: params[:content][:article_title][:value], 
                              body: params[:content][:article_body][:value],
                              description: params[:content][:article_description][:value]
    
    # Update page
    render text: ""
  end
  # POST /articles
  # POST /articles.xml
  def create
    @article = Article.new(params[:article])
    @article.author = current_member
    authorize! :create, @article
    @article.save
    respond_with(@article) do |format|
      format.html {
        redirect_to '/editor' + admin_article_path(@article)
      }
    end
  end

  def publish
    @article = Article.find(params[:id])
    authorize! :manage, @article
    @article.publish!
    respond_with @article do |format|
      format.json {
        render text: ""
      }
      format.html {
        redirect_to admin_article_path(@article)
      }
    end
  end

  # PUT /articles/1
  # PUT /articles/1.xml
  def update
    @article = Article.find(params[:id])
    authorize! :edit, @article
    @article.update_attributes!(params[:article])
    
    respond_with(@article) do |format|
      format.html {
        redirect_to admin_article_path(@article)
      }
    end
  end

  # DELETE /articles/1
  # DELETE /articles/1.xml
  def destroy
    @article = Article.find(params[:id])
    authorize! :destroy, @article
    @article.destroy
    respond_with(@article) do |format|
      format.html {
        redirect_to admin_articles_path
      }
    end
  end
end
