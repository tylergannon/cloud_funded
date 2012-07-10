require 'spec_helper'

describe "projects/categories/show" do
  before(:each) do
    @projects_category = assign(:projects_category, stub_model(Projects::Category,
      :name => "Name",
      :desription => "Desription"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    rendered.should match(/Desription/)
  end
end
