require "spec_helper"

describe PledgesController do
  describe "routing" do

    it "routes to #index" do
      get("/pledges").should route_to("pledges#index")
    end

    it "routes to #new" do
      get("/pledges/new").should route_to("pledges#new")
    end

    it "routes to #show" do
      get("/pledges/1").should route_to("pledges#show", :id => "1")
    end

    it "routes to #edit" do
      get("/pledges/1/edit").should route_to("pledges#edit", :id => "1")
    end

    it "routes to #create" do
      post("/pledges").should route_to("pledges#create")
    end

    it "routes to #update" do
      put("/pledges/1").should route_to("pledges#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/pledges/1").should route_to("pledges#destroy", :id => "1")
    end

  end
end
