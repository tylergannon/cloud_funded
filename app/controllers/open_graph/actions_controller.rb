class OpenGraph::ActionsController < ApplicationController
  respond_to :json
  before_filter :authenticate_member!
  load_and_authorize_resource class: 'OpenGraph::Action'
  
  def create
    @action.save!
    respond_with @action do |format|
      format.json {
        render text: ''
      }
    end
  end
end
