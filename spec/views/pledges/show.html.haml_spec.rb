require 'spec_helper'

describe "pledges/show" do
  before(:each) do
    @pledge = assign(:pledge, stub_model(Pledge,
      :amount => "9.99"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/9.99/)
  end
end
