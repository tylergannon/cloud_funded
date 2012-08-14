class OpenGraph::Pledge < OpenGraph::Action  
  def self.for_project(project, member)
    where(graph_object_type: project.class.name, graph_object_id: project.id, member_id: member.id).first
  end

  def pledge!
    self.class.action(:pledge, project_url(graph_object), member.fb_token, member.facebook_id)
  end

  private
  before_validation do |pledge_action|
    logger.debug "Going to do it!"
    pledge_action.action_id = self.pledge! unless pledge_action.action_id
  end
end
