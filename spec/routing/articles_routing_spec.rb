require "spec_helper"

describe ArticlesController do
  describe "routing" do
    it "routes to #index" do
      get("/articles").should route_to("articles#index")
    end

    it "routes to #show" do
      get("/articles/1").should route_to("articles#show", :id => "1")
    end
  end
end
