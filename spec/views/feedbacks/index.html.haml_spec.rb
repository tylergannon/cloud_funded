require 'spec_helper'

describe "feedbacks/index" do
  before(:each) do
    assign(:feedbacks, [
      stub_model(Feedback,
        :subject => "Subject",
        :body => "MyText",
        :member_id => 1,
        :about_page => "About Page"
      ),
      stub_model(Feedback,
        :subject => "Subject",
        :body => "MyText",
        :member_id => 1,
        :about_page => "About Page"
      )
    ])
  end

  it "renders a list of feedbacks" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Subject".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "About Page".to_s, :count => 2
  end
end
