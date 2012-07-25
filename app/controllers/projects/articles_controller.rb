class Projects::ArticlesController < ApplicationController
  before_filter :load_project
  
  def index
    @articles = @project.articles
    respond_with @project, @articles
  end
  
  def show
    @article = @project.articles.find(params[:id])
    @title = @article.title
    respond_with @project, @article
  end
  
  def load_project
    @project = Project.find params[:project_id]
  end
end
