module ApplicationHelper
  def facebook_app_id
    ENV['facebook_app_id']
  end
  
  def element_id(model)
    model.class.underscore + "_#{model.id}" 
  end

  def twitterized_type(type)
    case type
      when :alert
        "alert-block"
      when :error
        "alert-error"
      when :notice
        "alert-info"
      when :success
        "alert-success"
      else
        type.to_s
    end
  end
end
