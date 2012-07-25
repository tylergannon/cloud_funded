require "spec_helper"

describe FeedbacksController do
  describe "routing" do
    it "routes to #new" do
      get("/feedbacks/new").should route_to("feedbacks#new")
    end

    it "routes to #create" do
      post("/feedbacks").should route_to("feedbacks#create")
    end
  end
end
