require "spec_helper"

describe ProjectsController do
  describe "routing" do
    it 'routes to #show / default format' do
      get('/10').should route_to('projects#show', id: '10')
    end
    
    it 'routes to #show / default format' do
      get('/10.json').should route_to('projects#show', id: '10', format: 'json')
    end

    it 'routes to #show / default format' do
      post('/10.json').should route_to('projects#update', id: '10', format: 'json')
    end
    
    it "routes to #index" do
      get("/projects").should route_to("projects#index")
    end

    it "routes to #new" do
      get("/projects/fund_yours").should route_to("projects#new")
    end

    it "routes to #show" do
      get("/projects/1").should route_to("projects#show", :id => "1")
    end

    it "routes to #edit" do
      get("/projects/1/settings").should route_to("projects#edit", :id => "1")
    end

    it "routes to #create" do
      post("/projects").should route_to("projects#create")
    end

    it "routes to #update" do
      put("/projects/1").should route_to("projects#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/projects/1").should route_to("projects#destroy", :id => "1")
    end

  end
end
