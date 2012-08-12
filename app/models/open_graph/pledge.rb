class OpenGraph::Pledge < OpenGraph::Action  
  def self.for_project(project, member)
    where(graph_object_type: project.class.name, graph_object_id: project.id, member_id: member.id).first
  end

  def pledge(project)
    self.class.action(:pledge, project_url(project), current_member.fb_token, current_member.facebook_id)
  end
  
  private
  before_validation do |pledge_action|
    logger.debug "Going to do it!"
    pledge_action.action_id = self.launch(pledge_action.graph_object)
  end
end
