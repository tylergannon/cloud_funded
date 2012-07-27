class Projects::ArticlesController < ApplicationController
  before_filter :load_project, :authenticate_member!
  
  def index
    @articles = @project.articles.accessible_by(current_ability)
    respond_with @project, @articles
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
