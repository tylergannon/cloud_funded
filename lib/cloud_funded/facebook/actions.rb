module CloudFunded
  module Facebook
    class Actions
      include HTTParty
      format :json
      base_uri 'https://graph.facebook.com'
      # curl -F 'access_token=AAAEyIBSfsVoBAC8nGKWEAnC75Dc9C815i0GsGjwLWWhcIsiUJGKLBrRDEPgBxzPmt6bsBpOJ9oWgZAusMCURzUziq5rCiGCSs2dxVzgZDZD' \
      #      -F 'project=http://demo.cloudfunded.com/projects/nourish-cafe' \
      #         'https://graph.facebook.com/me/cloudfunded:create'
      def self.create_project(project_url, access_token)
        action(:create, project_url, access_token)
      end

      def self.pledge_to_project(project_url, access_token)
        action(:pledge_to_support, project_url, access_token)
      end
      
      private
      def self.action(action, project_url, access_token)
        response = self.post("/me/cloudfunded:#{action}", query: {project: project_url, access_token: access_token})
        unless (response["id"].to_i > 0)
          raise response.inspect
        end
      end
    end
  end
end