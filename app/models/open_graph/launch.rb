class OpenGraph::Launch < OpenGraph::Action
  include Rails.application.routes.url_helpers
  default_url_options[:host] = CloudFunded::Application.config.action_mailer.default_url_options[:host]
  include HTTParty
  format :json
  base_uri 'https://graph.facebook.com'
  
  def self.for_project(project)
    where(graph_object_type: project.class.name, graph_object_id: project.id).first
  end

  def launch(project)
    self.class.action(:launch, project_url(project), project.owner.fb_token, project.owner.facebook_id)
  end
  
  private
  before_validation do |launch_action|
    logger.debug "Going to do it!"
    launch_action.action_id = self.launch(launch_action.graph_object)
  end
end
