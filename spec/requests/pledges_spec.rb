require 'spec_helper'

describe "Pledges" do
  describe "GET /pledges" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get project_pledges_path(FactoryGirl.create(:project))
      response.status.should be(200)
    end
  end
end
