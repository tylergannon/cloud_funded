require "spec_helper"

describe Projects::RolesController do
  describe "routing" do
    it "should route to confirm" do
      get('/projects/google/roles/123/confirm').should route_to('projects/roles#confirm', id: '123', project_id: 'google')
    end
  end
end
