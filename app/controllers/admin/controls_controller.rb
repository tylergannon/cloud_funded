class Admin::ControlsController < ApplicationController
  before_filter :authenticate_admin
  def index
    
  end
  
  def authenticate_admin
    authorize! :manage, Page
  end
end