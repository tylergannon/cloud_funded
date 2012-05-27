require 'spec_helper'

describe "feedbacks/new" do
  before(:each) do
    assign(:feedback, stub_model(Feedback,
      :subject => "MyString",
      :body => "MyText",
      :member_id => 1,
      :about_page => "MyString"
    ).as_new_record)
  end

  it "renders new feedback form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => feedbacks_path, :method => "post" do
      assert_select "input#feedback_subject", :name => "feedback[subject]"
      assert_select "textarea#feedback_body", :name => "feedback[body]"
      assert_select "input#feedback_member_id", :name => "feedback[member_id]"
      assert_select "input#feedback_about_page", :name => "feedback[about_page]"
    end
  end
end
