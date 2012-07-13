require 'spec_helper'

describe AccountsController do
  render_views
  
  before :each do
    sign_in_as_member
  end
  
  describe "get #show" do
    it "should load the current member" do
      get :show
      assigns(:member).should == @member
    end
  end
end
