require 'spec_helper'

describe OpenGraph::Launch do
  before :each do
    sign_in_as_member
    @project = FactoryGirl.create :live_project, 
  end
  
end