class OpenGraph::ActionsController < ApplicationController
  respond_to :json
  before_filter :authenticate_member!, except: [:follow]
  
  def follow
    data = decode_data(params[:signed_request])
    fb_id = data["user_id"]
    url = data["objects"][0]["url"]
    
    @member = Member.where(facebook_id: fb_id).first
    @project = Project.find(url.match(/[a-zA-Z0-9\-]+$/)[0])
    @member.followed_projects << @project
    @action_id = data["actions"][0]["id"]

    OpenGraph::Follow.create member: @member, graph_object: @project, action_id: @action_id

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
    respond_to do |format|
      format.json {
        render text: 'success'
      }
    end
  end
  
  def base64_url_decode str
    encoded_str = str.gsub('-','+').gsub('_','/')
    encoded_str += '=' while !(encoded_str.size % 4).zero?
    Base64.decode64(encoded_str)
  end

  def decode_data str
    encoded_sig, payload = str.split('.')
    data = ActiveSupport::JSON.decode base64_url_decode(payload)
  end
  
end
