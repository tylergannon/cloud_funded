class Projects::ArticlesController < ApplicationController
  respond_to :html, :js, :json
  before_filter :load_project, :authenticate_member!
  
  def index
    @articles = @project.articles.accessible_by(current_ability)
    respond_with @project, @articles
  end
  
  def create
    authorize! :manage, @project
    @article = Article.new
    @article.project = @project
    @article.author = current_member
    @article.save
    respond_with @project, @article
  end
  
  def show
    @article = @project.articles.find(params[:id])
    authorize! :read, @article
    @title = @article.title
    respond_with @project, @article
  end
  
  def publish
    @article = @project.articles.find(params[:id])
    authorize! :manage, @article
    @article.publish!
    respond_with @project, @article do |format|
      format.json {
        render text: ""
      }
    end
  end
  
  def load_project
    @project = Project.find params[:project_id]
  end
end
