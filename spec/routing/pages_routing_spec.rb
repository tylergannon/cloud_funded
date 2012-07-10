require "spec_helper"

describe PagesController do
  describe "routing" do
    it "routes to #show" do
      get("/pages/1").should route_to("pages#show", :id => "1")
    end
  end
end
