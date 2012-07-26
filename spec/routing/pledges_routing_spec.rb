require "spec_helper"

describe PledgesController do
  describe "Routing: Resources for Pledges" do
    # it "routes new pledge" do  #  No it doesn't, we have a wizard.
    #   get("/projects/nice/pledge").should route_to("pledges#new", :project_id => "nice")
    # end
    it "routes to my pledge" do
      get("/projects/nice/my_pledge").should route_to("pledges#show", :project_id => "nice")
    end

    it "routes to #index" do
      get("/projects/nice/pledges").should route_to("pledges#index", :project_id => "nice")
    end

    # it "routes to #new" do    #   Nuh uh tupid
    #   get("/projects/nice/pledge").should route_to("pledges#new", :project_id => "nice")
    # end

    it "routes to #show" do
      get("/projects/nice/pledges/1").should route_to("pledges#show", :id => "1", :project_id => "nice")
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
