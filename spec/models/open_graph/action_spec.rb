require 'spec_helper'

describe OpenGraph::Action do
  subject {FactoryGirl.build :open_graph_action}
  
  it {should belong_to(:member)}
  it {should belong_to(:graph_object)}
  it {should have_db_column(:action_id).of_type(:string)}
  
  it {should validate_presence_of(:action_id)}
  it {should validate_presence_of(:graph_object_type)}
  it {should validate_presence_of(:graph_object_id)}
  it {should validate_presence_of(:member_id)}
  it {should validate_presence_of(:type)}
end
