require "spec_helper"

describe PledgesController do
  describe "routing" do

    it "routes to #index" do
      get("/projects/nice/pledges").should route_to("pledges#index", :project_id => "nice")
    end

    it "routes to #new" do
      get("/projects/nice/pledges/new").should route_to("pledges#new", :project_id => "nice")
    end

    it "routes to #show" do
      get("/projects/nice/pledges/1").should route_to("pledges#show", :id => "1", :project_id => "nice")
    end

    it "routes to #edit" do
      get("/projects/nice/pledges/1/edit").should route_to("pledges#edit", :id => "1", :project_id => "nice")
    end

    it "routes to #create" do
      post("/projects/nice/pledges").should route_to("pledges#create", :project_id => "nice")
    end

    it "routes to #update" do
      put("/projects/nice/pledges/1").should route_to("pledges#update", :id => "1", :project_id => "nice")
    end

    it "routes to #destroy" do
      delete("/projects/nice/pledges/1").should route_to("pledges#destroy", :id => "1", :project_id => "nice")
    end

  end
end
