class OpenGraph::ActionsController < ApplicationController
  respond_to :json
  before_filter :authenticate_member!, except: [:follow]
  
  def follow
    File.open('follow.yml', 'w') {|f|
      f.write params.to_yaml
    }
    logger.error params.to_yaml
    respond_to do |format|
      format.json {
        render text: 'success'
      }
    end
  end
  
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
