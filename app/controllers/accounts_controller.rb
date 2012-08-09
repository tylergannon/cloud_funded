class AccountsController < ApplicationController
  before_filter :authenticate_member!, :load_member
  respond_to :json
  
  before_filter do |controller|
    session[:last_request] = request.path if request.format == 'text/html'
  end

  def show
    respond_with @member do |format|
      format.html {
        render layout: 'my_account'
      }
    end
  end
  
  def search
    raise "I don't do nil" if params[:q].blank?
    puts ["email like ? OR full_name like ?", "%#{params[:q]}%", "%#{params[:q]}%"].inspect
    @members = Member.where("email like ? OR full_name like ?", "%#{params[:q]}%", "%#{params[:q]}%").
                      select('full_name, profile_pic, id, slug').limit(10)
    respond_with @members
  end
  
  def send_reset_password_instructions
    @member.send_reset_password_instructions
    respond_to do |format|
      format.js {
        render action: 'send_reset_password_instructions'
      }
    end
  end
  
  def dwolla_auth_failure
    flash[:error] = "Why you no like Dwolla?"
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
