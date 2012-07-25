require "spec_helper"

describe Admin::Projects::CategoriesController do
  describe "routing" do

    it "routes to #index" do
      get("/admin/projects/categories").should route_to("admin/projects/categories#index")
    end

    it "routes to #new" do
      get("/admin/projects/categories/new").should route_to("admin/projects/categories#new")
    end

    it "routes to #show" do
      get("/admin/projects/categories/1").should route_to("admin/projects/categories#show", :id => "1")
    end

    it "routes to #edit" do
      get("/admin/projects/categories/1/edit").should route_to("admin/projects/categories#edit", :id => "1")
    end

    it "routes to #create" do
      post("/admin/projects/categories").should route_to("admin/projects/categories#create")
    end

    it "routes to #update" do
      put("/admin/projects/categories/1").should route_to("admin/projects/categories#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/admin/projects/categories/1").should route_to("admin/projects/categories#destroy", :id => "1")
    end

  end
end
