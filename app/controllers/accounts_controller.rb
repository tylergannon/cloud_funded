class AccountsController < ApplicationController
  before_filter :authenticate_member!, :load_member
  
  before_filter do |controller|
    session[:last_request] = request.path if request.format == 'text/html'
  end

  def show
    respond_with @member
  end
  
  def edit
    respond_with @member
  end
  
  def update
    @member.update_attributes params[:member]
    respond_with @member do |format|
      format.html {
        redirect_to account_path
      }
    end
  end
  
  def load_member
    @member = current_member
  end
end
