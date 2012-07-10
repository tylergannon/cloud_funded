require "spec_helper"

describe Projects::TransactionsController do
  describe "routing" do

    it "routes to #index" do
      get("/projects/123/transactions").should route_to("projects/transactions#index", project_id: '123')
    end

    it "routes to #new" do
      get("/projects/123/transactions/new").should route_to("projects/transactions#new", project_id: '123')
    end

    it "routes to #show" do
      get("/projects/2/transactions/1").should route_to("projects/transactions#show", :id => "1", project_id: '2')
    end

    it "routes to #edit" do
      get("/projects/2/transactions/1/edit").should route_to("projects/transactions#edit", :id => "1", project_id: '2')
    end

    it "routes to #create" do
      post("/projects/2/transactions").should route_to("projects/transactions#create", project_id: '2')
    end

    it "routes to #update" do
      put("/projects/123/transactions/32").should route_to("projects/transactions#update", :id => "32", project_id: '123')
    end

    it "routes to #destroy" do
      delete("/projects/12/transactions/43").should route_to("projects/transactions#destroy", :id => "43", project_id: '12')
    end
  end
end
