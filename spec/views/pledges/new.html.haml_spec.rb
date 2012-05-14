require 'spec_helper'

describe "pledges/new" do
  before(:each) do
    assign(:pledge, stub_model(Pledge,
      :amount => "9.99"
    ).as_new_record)
  end

  it "renders new pledge form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => pledges_path, :method => "post" do
      assert_select "input#pledge_amount", :name => "pledge[amount]"
    end
  end
end
