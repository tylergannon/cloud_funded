require 'spec_helper'

describe "pledges/edit" do
  before(:each) do
    @project = assign(:project, FactoryGirl.create(:project))
    @pledge = assign(:pledge, FactoryGirl.create(:pledge, project: @project))
  end

  it "renders the edit pledge form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => project_pledges_path(@project, @pledge), :method => "post" do
      assert_select "input#pledge_amount", :name => "pledge[amount]"
    end
  end
end
