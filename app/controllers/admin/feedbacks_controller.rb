class Admin::FeedbacksController < ApplicationController
  # GET /feedbacks
  # GET /feedbacks.xml
  def index
    @feedbacks = Feedback.all
    respond_with(@feedbacks) do |format|
      format.html {
        render layout: 'admin'
      }
    end
  end

  # GET /feedbacks/1
  # GET /feedbacks/1.xml
  def show
    @feedback = Feedback.find(params[:id])
    respond_with(@feedback)
  end

  # GET /feedbacks/new
  # GET /feedbacks/new.xml
  def new
    @feedback = Feedback.new
    respond_with(@feedback)
  end

  # GET /feedbacks/1/edit
  def edit
    @feedback = Feedback.find(params[:id])
  end

  # POST /feedbacks
  # POST /feedbacks.xml
  def create
    @feedback = Feedback.new(params[:feedback])
    @feedback.save
    respond_with(@feedback)
  end

  # PUT /feedbacks/1
  # PUT /feedbacks/1.xml
  def update
    @feedback = Feedback.find(params[:id])
    @feedback.update_attributes(params[:feedback])
    respond_with(@feedback)
  end

  # DELETE /feedbacks/1
  # DELETE /feedbacks/1.xml
  def destroy
    @feedback = Feedback.find(params[:id])
    @feedback.destroy
    respond_with(@feedback)
  end
end
