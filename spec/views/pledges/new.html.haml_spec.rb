require 'spec_helper'

describe "pledges/new" do
  before(:each) do
    @project = FactoryGirl.create(:project)
    assign(:project, @project)
    assign(:pledge, FactoryGirl.build(:pledge, project: @project))
  end

  it "renders new pledge form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => project_pledges_path(@project), :method => "post" do
      assert_select "input#pledge_amount", :name => "pledge[amount]"
    end
  end
end
