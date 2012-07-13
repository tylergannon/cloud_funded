class AccountsController < ApplicationController
  before_filter :authenticate_member!
  
  def show
    respond_with @member
  end
  
  def edit
    respond_with @member
  end
  
  def change_password
    respond_with @member
  end
  
  def update
    @member.update_attributes params[:member]
    respond_with @member
  end
  
  def load_member
    @member = current_member
  end
end
