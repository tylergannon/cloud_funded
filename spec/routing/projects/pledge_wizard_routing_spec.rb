require "spec_helper"

describe Projects::PledgeWizardController do
  describe "routing" do
    it "should route /get_funded to projects#edit" do
      get('/google/pledge').should route_to('projects/pledge_wizard#show', project_id: 'google')
    end

    it "should route /get_funded to projects#edit?id=nice" do
      get('/google/pledge/nice').should route_to('projects/pledge_wizard#show', project_id: 'google', id: 'nice')
    end
    
    it "should route to #update" do
      put('/google/pledge').should route_to('projects/pledge_wizard#update', project_id: 'google')
    end

    it "should route to #update wth id" do
      put('/google/pledge/cool').should route_to('projects/pledge_wizard#update', project_id: 'google', id: 'cool')
    end
    
    it "should map get_funded_path to /get_funded" do
      project = FactoryGirl.create :live_project
      new_project_pledge_path(project).should == "/#{project.to_param}/pledge"
    end
  end
end
