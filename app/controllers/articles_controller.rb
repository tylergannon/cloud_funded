class ArticlesController < ApplicationController
  respond_to :html, :atom
  # GET /articles
  # GET /articles.xml
  def index
    @articles = Article.where published: true
    respond_with(@articles) do |format|

    end
  end

  # GET /articles/1
  # GET /articles/1.xml
  def show
    @article = Article.find(params[:id])
    respond_with(@article)
  end
end
