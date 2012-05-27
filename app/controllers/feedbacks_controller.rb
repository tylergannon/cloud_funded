class FeedbacksController < ApplicationController
  def show
    @feedback = Feedback.find(params[:id])
    respond_with(@feedback)
  end

  def new
    authorize! :create, Feedback
    @feedback = Feedback.new(member: current_member, about_page: params[:about_page])
    # raise 'fooolio'
    
    respond_with(@feedback)
  end

  def create
    @feedback = Feedback.new(params[:feedback])
    @feedback.save
    respond_with(@feedback) do |format|
      format.html {
        redirect_to feedback_received_path
      }
    end
  end
end
