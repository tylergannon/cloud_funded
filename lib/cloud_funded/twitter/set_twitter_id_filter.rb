module CloudFunded
  module Twitter
    class SetTwitterIdFilter
      def self.filter(controller)
        if controller.member_signed_in? && controller.session[:twitter_login_id]
          controller.current_member.update_attributes! twitter_login_id: controller.session[:twitter_login_id]
        end
      end
    end
  end
end

