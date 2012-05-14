require 'spec_helper'

describe "pledges/edit" do
  before(:each) do
    @pledge = assign(:pledge, stub_model(Pledge,
      :amount => "9.99"
    ))
  end

  it "renders the edit pledge form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => pledges_path(@pledge), :method => "post" do
      assert_select "input#pledge_amount", :name => "pledge[amount]"
    end
  end
end
