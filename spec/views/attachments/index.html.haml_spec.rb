require 'spec_helper'

describe "attachments/index" do
  before(:each) do
    assign(:attachments, [
      stub_model(Attachment,
        :title => "Title"
      ),
      stub_model(Attachment,
        :title => "Title"
      )
    ])
  end

  it "renders a list of attachments" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Title".to_s, :count => 2
  end
end
