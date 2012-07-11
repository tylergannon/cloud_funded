require "spec_helper"

describe PledgesController do
  describe "Routing: Resources for Pledges" do
    it "routes new pledge" do
      get("/projects/nice/updates/new").should route_to("projects/articles#new", :project_id => "nice")
    end
    it "routes to edit" do
      get("/projects/nice/updates/123/edit").should route_to("projects/articles#edit", :project_id => "nice", id: '123')
    end

    it "routes to #index" do
      get("/projects/nice/updates").should route_to("projects/articles#index", :project_id => "nice")
    end

    it "routes to #show" do
      get("/projects/nice/updates/1").should route_to("projects/articles#show", :id => "1", :project_id => "nice")
    end

    it "routes to #create" do
      post("/projects/nice/updates").should route_to("projects/articles#create", :project_id => "nice")
    end

    it "routes to #update" do
      put("/projects/nice/updates/1").should route_to("projects/articles#update", :id => "1", :project_id => "nice")
    end

    it "routes to #destroy" do
      delete("/projects/nice/updates/1").should route_to("projects/articles#destroy", :id => "1", :project_id => "nice")
    end
  end
end
