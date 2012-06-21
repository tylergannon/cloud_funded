class ProfilesController < ApplicationController
  def index
    @members = Member.all
    respond_with @members
  end
  
  def show
    if params[:id]
      @member = Member.find(params[:id])
    else
      @member = current_member
    end
    respond_with @member
  end
  
  def edit
    @member = current_member
    authorize! :edit, @member
  end
  
  def update
    @member = current_member
    authorize! :edit, @member
    @member.update_attributes(params[:profile])
    respond_with @member do |format|
      format.html {
        redirect_to profile_path(@member)
      }
    end
  end
end
