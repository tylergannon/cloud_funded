require 'spec_helper'

describe OpenGraph::ActionsController do
  before :each do
    sign_in_as_member
  end
  describe '#create' do
    # describe "when signed in as admin" do
    #   it "should still create the "
    # end
    it "should create an object" do
      expect {
        post :create, open_graph_action: {
          action_id: '2345234523452345',
          type: 'OpenGraph::Like',
          graph_object_type: 'Project',
          graph_object_id: 1234123
        }
      }.to change(OpenGraph::Action, :count).by(1)
    end
    
    describe "creates an open graph action record with the correct attributes" do
      before :each do
        post :create, open_graph_action: {
          action_id: '2345234523452345',
          type: 'OpenGraph::Like',
          graph_object_type: 'Project',
          graph_object_id: 1234123
        }
        @action = OpenGraph::Action.last
      end
      it "should have the correct action_id" do
        @action.action_id.should == '2345234523452345'
      end
      it "should have the correct type" do
        @action.type.should == 'OpenGraph::Like'
      end
      it "should have the correct graph_object_type" do
        @action.graph_object_type.should == 'Project'
      end
      it "should have the correct graph_object_id" do
        @action.graph_object_id.should == 1234123
      end
      it "should have the correct member_id" do
        @action.member_id.should == @member.id
      end
    end
  end
end
