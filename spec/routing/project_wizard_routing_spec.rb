require "spec_helper"

describe Projects::WizardController do
  describe "routing" do
    it "should route /get_funded to projects#edit" do
      get('/get_funded').should route_to('projects/wizard#show')
    end
    
    it "should route to #update" do
      put('/get_funded').should route_to('projects/wizard#update')
    end
    
    it "should map get_funded_path to /get_funded" do
      get_funded_path.should == '/get_funded'
    end
    
    describe "default route to show projects" do
      it "routes /nicebaz" do
        get("/nicebaz").should route_to("projects#show", :id => "nicebaz")
      end
      
      it "does not route anything with characters other than a-z and -." do
        get('/nice.jpg').should_not be_routable
      end
      
      it "does not route anything in a subdirectory" do
        get('/some/old/bullshit').should_not be_routable
      end
      
      it "should have the correct path for a project" do
        stub_project_attachments
        name    = 'Nice Bar'
        project = FactoryGirl.create :project, name: name
        project_path(project).should == '/nice-bar'
      end
    end
  end
end
