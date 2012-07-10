require "spec_helper"

describe Projects::CategoriesController do
  describe "routing" do

    it "routes to #index" do
      get("/projects/categories").should route_to("projects/categories#index")
    end

    it "routes to #show" do
      get("/projects/categories/1").should route_to("projects/categories#show", :id => "1")
    end

    # it "routes to #new" do
    #   get("/projects/categories/new").should_not be_routable
    # end
    # 
    # it "routes to #edit" do
    #   get("/projects/categories/1/edit").should_not be_routable
    # end
    # 
    # it "routes to #create" do
    #   post("/projects/categories").should_not be_routable
    # end
    # 
    # it "routes to #update" do
    #   put("/projects/categories/1").should_not be_routable
    # end
    # 
    # it "routes to #destroy" do
    #   delete("/projects/categories/1").should_not be_routable
    # end

  end
end
