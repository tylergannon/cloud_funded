require 'spec_helper'

describe "projects/categories/index" do
  before(:each) do
    assign(:projects_categories, [
      stub_model(Projects::Category,
        :name => "Name",
        :desription => "Desription"
      ),
      stub_model(Projects::Category,
        :name => "Name",
        :desription => "Desription"
      )
    ])
  end

  it "renders a list of projects/categories" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Desription".to_s, :count => 2
  end
end
