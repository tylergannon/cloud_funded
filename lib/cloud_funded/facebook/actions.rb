module CloudFunded
  module Facebook
    class Actions
      include Rails.application.routes.url_helpers
      default_url_options[:host] = CloudFunded::Application.config.action_mailer.default_url_options[:host]
      include HTTParty
      format :json
      base_uri 'https://graph.facebook.com'
      # curl -F 'access_token=AAAEyIBSfsVoBAC8nGKWEAnC75Dc9C815i0GsGjwLWWhcIsiUJGKLBrRDEPgBxzPmt6bsBpOJ9oWgZAusMCURzUziq5rCiGCSs2dxVzgZDZD' \
      #      -F 'project=http://demo.cloudfunded.com/projects/nourish-cafe' \
      #         'https://graph.facebook.com/me/cloudfunded:create'
      def self.launch_project(project_url, access_token)
        action(:launch, project_url, access_token)
      end
      
      def launch(project)
        action(:launch, project_url(project), project.owner.fb_token)
      end
      
      def self.pledge_to_support(project_url, access_token)
        action(:pledge, project_url, access_token)
      end

      def self.remove_action(id, access_token)
        response = self.delete("/#{id}", query: {access_token: access_token})
      end
      
      private
      def self.action(action, project_url, access_token)
        Rails.logger.debug "Going to post to to Facebook.  Action: #{action}, Project: #{project_url}"
        response = self.post("/me/#{AppConfig.opengraph_namespace}:#{action}", query: {project: project_url, access_token: access_token})
        Rails.logger.debug response.inspect
        if response["id"].nil?
          Rails.logger.error "Unable to post to facebook: #{response.inspect}"
        end
        response["id"]
      end
    end
  end
end