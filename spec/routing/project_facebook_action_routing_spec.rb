require 'spec_helper'

describe FacebookActionsController do
  describe "routing" do
    it "routes to #destroy" do
      delete("/projects/nice/facebook_action").should route_to("facebook_actions#destroy", :project_id => "nice")
    end
  end
end