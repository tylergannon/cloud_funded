require 'spec_helper'

describe Admin::ArticlesController do
  describe "Routing: Resources for articles" do
    it "routes to #publish" do
      post("/admin/articles/123/publish").should route_to("admin/articles#publish", id: '123')
    end
  end
end
