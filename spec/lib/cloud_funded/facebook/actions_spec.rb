require 'spec_helper'

describe CloudFunded::Facebook::Actions do
  describe '#create_project' do
    # curl -F 'access_token=AAAEyIBSfsVoBAC8nGKWEAnC75Dc9C815i0GsGjwLWWhcIsiUJGKLBrRDEPgBxzPmt6bsBpOJ9oWgZAusMCURzUziq5rCiGCSs2dxVzgZDZD' \
    #      -F 'project=http://demo.cloudfunded.com/projects/nourish-cafe' \
    #         'https://graph.facebook.com/me/cloudfunded:create'
    it "should create the project" do
      VCR.use_cassette 'Create Project Success' do
        access_token = 'AAAEyIBSfsVoBAPyuLrDZCwn2VRJkdo5phtX2UKSc28LEsy2HpUrK7PuATyLhDjInkWEIDZBPyYZClCBKIvlhgjhS8s4LKXNqPZCoGfm6KgZDZD'
        project_url  = 'http://demo.cloudfunded.com/projects/nourish-cafe'
        CloudFunded::Facebook::Actions.create_project(project_url, access_token).should be_true
      end
    end
    describe "when there is an error" do
      it "should be false" do
        VCR.use_cassette 'Create Project Failure' do
          access_token = 'AAAEyIBSfsVoBAPyuLrDsdffkdo5phtX2UKSc28LEsy2HpUrK7PuATyLhDjInkWEIDZBPyYZClCBKIvlhgjhS8s4LKXNqPZCoGfm6KgZDZD'
          project_url  = 'http://demo.cloudfunded.com/projects/nourish-cafe'
          CloudFunded::Facebook::Actions.create_project(project_url, access_token).should be_false
        end
      end
    end
  end
end