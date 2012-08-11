class OpenGraph::Launch < OpenGraph::Action
  include Rails.application.routes.url_helpers
  default_url_options[:host] = CloudFunded::Application.config.action_mailer.default_url_options[:host]
  include HTTParty
  format :json
  base_uri 'https://graph.facebook.com'

  def self.launch_project(project_url, access_token)
    action(:launch, project_url, access_token)
  end
  
  def launch(project)
    self.class.action(:launch, project_url(project), project.owner.fb_token, project.owner.facebook_id)
  end
  
  def self.pledge_to_support(project_url, access_token)
    action(:pledge, project_url, access_token)
  end
  
  private
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

  before_create do |launch|
    CloudFunded::Facebook::Actions.launch(launch.open_graph_object)
  end
end
