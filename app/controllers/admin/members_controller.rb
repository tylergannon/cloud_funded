class Admin::MembersController < ApplicationController
  respond_to :html
  before_filter :authorize_admin
  
  def index
    @members = Member.all
    respond_with(@members)
  end

  def new
    @member = Member.new(params[:member])
    respond_with(@member)
  end
  
  def show
    @member = Member.find(params[:id])
    respond_with(@member)
  end

  def edit
    @member = Member.find(params[:id])
    respond_with(@member)
  end
  # 
  # @pledge = @project.pledges.create({investor: current_member}.merge(params[:pledge]))
  # authorize! :create, @pledge
  # respond_with @project, @pledge do |format|
  #   format.html {
  #     if @pledge.valid?
  #       redirect_to @project
  #     end
  #   }
  # end
  # 

  
  def create
    @member = Member.new(params[:member])
    @member.skip_confirmation!
    @member.save
    
    puts @member.errors.inspect

    respond_with(@member) do |format|
      format.html {
        if @member.valid?
          redirect_to admin_members_path
        else
          render action: :new
        end
      }
    end
  end
  
  def update
    @member = Member.find(params[:id])
    if params[:member][:password].blank?
      attrs = params[:member].except(:password, :password_confirmation)
    else
      attrs = params[:member]
    end
    @member.update_attributes(attrs)

    respond_with(@member) do |format|
      format.html {
        redirect_to admin_members_path
      }
    end
  end
  
  def destroy
    @member = Member.find(params[:id])
    @member.destroy
    respond_with(@member) do |format|
      format.html {
        redirect_to admin_members_path
      }
    end
  end
  
  def authorize_admin
    authenticate_member!
    authorize! :manage, Member
  end
end
