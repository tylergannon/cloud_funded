require "spec_helper"

describe Projects::AdminsController do
  describe "routing" do
    it "should route to create" do
      post('/projects/google/admins.js').should route_to('projects/admins#create', project_id: 'google', format: :js)
    end
  end
end
