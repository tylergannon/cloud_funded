class OpenGraph::Action < ActiveRecord::Base
  attr_accessible :action_id, :member_id, :type, :graph_object, :graph_object_id, :graph_object_type, :member
  belongs_to :member
  belongs_to :graph_object, polymorphic: true
  
  validates :member_id, presence: true
  validates :type, presence: true
  validates :graph_object_id, presence: true
  validates :graph_object_type, presence: true
  validates :action_id, presence: true
  
  def self.action(action, project_url, access_token, facebook_id)
    logger.debug "Going to post to to Facebook."
    logger.debug "project: #{project_url}"
    logger.debug "access token: #{access_token}"
    logger.debug "path: /#{facebook_id}/#{AppConfig.opengraph_namespace}:#{action}"
    logger.debug facebook_id
    response = self.post("/me/#{AppConfig.opengraph_namespace}:#{action}", query: {campaign: project_url, access_token: access_token})
    logger.debug response.inspect
    if response["id"].nil?
      logger.error "Unable to post to facebook: #{response.inspect}"
    end
    response["id"]
  end
end
