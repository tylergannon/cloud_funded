module OpenGraph::ActionsHelper
  def shared_pledge?
    !(@share_action ||= OpenGraph::Pledge.for_project(@project, current_member)).nil?
  end
end