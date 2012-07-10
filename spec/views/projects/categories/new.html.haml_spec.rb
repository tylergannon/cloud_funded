require 'spec_helper'

describe "projects/categories/new" do
  before(:each) do
    assign(:projects_category, stub_model(Projects::Category,
      :name => "MyString",
      :desription => "MyString"
    ).as_new_record)
  end

  it "renders new projects_category form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => projects_categories_path, :method => "post" do
      assert_select "input#projects_category_name", :name => "projects_category[name]"
      assert_select "input#projects_category_desription", :name => "projects_category[desription]"
    end
  end
end
