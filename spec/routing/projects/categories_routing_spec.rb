require "spec_helper"

describe Projects::CategoriesController do
  describe "routing" do

    it "routes to #index" do
      get("/projects/categories").should route_to("projects/categories#index")
    end

    it "routes to #new" do
      get("/projects/categories/new").should route_to("projects/categories#new")
    end

    it "routes to #show" do
      get("/projects/categories/1").should route_to("projects/categories#show", :id => "1")
    end

    it "routes to #edit" do
      get("/projects/categories/1/edit").should route_to("projects/categories#edit", :id => "1")
    end

    it "routes to #create" do
      post("/projects/categories").should route_to("projects/categories#create")
    end

    it "routes to #update" do
      put("/projects/categories/1").should route_to("projects/categories#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/projects/categories/1").should route_to("projects/categories#destroy", :id => "1")
    end

  end
end
