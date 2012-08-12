class OpenGraph::ActionsController < ApplicationController
  respond_to :json
  before_filter :authenticate_member!
  
  def create
    @action = params[:open_graph_action][:type].constantize.new(params[:open_graph_action])
    @action.member = current_member
    authorize! :create, @action
    @action.save!
    respond_with @action do |format|
      format.json {
        render text: ''
      }
    end
  end
end
