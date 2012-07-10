require 'spec_helper'

describe "projects/categories/edit" do
  before(:each) do
    @projects_category = assign(:projects_category, stub_model(Projects::Category,
      :name => "MyString",
      :desription => "MyString"
    ))
  end

  it "renders the edit projects_category form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => projects_categories_path(@projects_category), :method => "post" do
      assert_select "input#projects_category_name", :name => "projects_category[name]"
      assert_select "input#projects_category_desription", :name => "projects_category[desription]"
    end
  end
end
