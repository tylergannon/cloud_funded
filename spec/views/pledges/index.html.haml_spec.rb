require 'spec_helper'

describe "pledges/index" do
  before(:each) do
    assign(:pledges, [
      stub_model(Pledge,
        :amount => "9.99"
      ),
      stub_model(Pledge,
        :amount => "9.99"
      )
    ])
  end

  it "renders a list of pledges" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
  end
end
