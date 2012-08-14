class ArticlesController < ApplicationController
  respond_to :html, :atom
  # GET /articles
  # GET /articles.xml
  def index
    @title = "Official CloudFunded Blog"
    @articles = Article.where(workflow_state: 'published', project_id: nil)
    respond_with(@articles) do |format|
    end
  end

  # GET /articles/1
  # GET /articles/1.xml
  def show
    @article = Article.find(params[:id])
    @title = @article.title
    respond_with(@article)
  end
end
