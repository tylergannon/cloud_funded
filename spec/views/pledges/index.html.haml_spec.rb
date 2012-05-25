require 'spec_helper'

describe "pledges/index" do
  before(:each) do
    @project = assign(:project, FactoryGirl.create(:project))
    assign(:pledges, [
      FactoryGirl.create(:pledge, project: @project),
      FactoryGirl.create(:pledge, project: @project)
    ])
  end

  it "renders a list of pledges" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
  end
end
