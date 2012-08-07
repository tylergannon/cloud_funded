require 'spec_helper'

describe AccountsController do
  describe 'routing' do
    it "routes to #show" do
      get("/my_account").should route_to("accounts#show")
    end
    
    it "routes to send_reset_password_instructions" do
      put('/my_account/send_reset_password_instructions').should route_to('accounts#send_reset_password_instructions')
    end

    it "routes to #edit" do
      get("/my_account/edit").should route_to("accounts#edit")
    end

    it "routes to #update" do
      put("/my_account").should route_to("accounts#update")
    end
  end
end