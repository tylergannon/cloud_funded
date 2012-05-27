class Admin::ArticlesController < ApplicationController
  def index
    @articles = Article.all
    respond_with(@articles)
  end

  # GET /articles/1
  # GET /articles/1.xml
  def show
    @article = Article.find(params[:id])
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

  # PUT /articles/1
  # PUT /articles/1.xml
  def update
    @article = Article.find(params[:id])
    authorize! :edit, @article
    puts "get it????"
    puts params[:article].inspect
    @article.update_attributes!(params[:article])
    
    puts "********" * 10
    puts @article.errors.inspect
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
