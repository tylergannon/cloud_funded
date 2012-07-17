require "spec_helper"

describe Projects::PerksController do
  describe "Routing: Resources for Perks" do
    it "routes new perks" do
      get("/projects/nice/perks/new").should route_to("projects/perks#new", :project_id => "nice")
    end
    it "routes to edit" do
      get("/projects/nice/perks/123/edit").should route_to("projects/perks#edit", :project_id => "nice", id: '123')
    end

    it "routes to #index" do
      get("/projects/nice/perks").should route_to("projects/perks#index", :project_id => "nice")
    end

    it "routes to #show" do
      get("/projects/nice/perks/1").should route_to("projects/perks#show", :id => "1", :project_id => "nice")
    end

    it "routes to #create" do
      post("/projects/nice/perks").should route_to("projects/perks#create", :project_id => "nice")
    end

    it "routes to #update" do
      put("/projects/nice/perks/1").should route_to("projects/perks#update", :id => "1", :project_id => "nice")
    end

    it "routes to #destroy" do
      delete("/projects/nice/perks/1").should route_to("projects/perks#destroy", :id => "1", :project_id => "nice")
    end
  end
end
