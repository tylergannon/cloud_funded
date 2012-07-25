module ApplicationHelper
  def facebook_app_id
    ENV['facebook_app_id']
  end
  
  def element_id(model)
    model.class.underscore + "_#{model.id}" 
  end
end
