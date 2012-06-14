module ApplicationHelper
  def facebook_app_id
    '336588343062874'
  end
  
  def element_id(model)
    model.class.underscore + "_#{model.id}" 
  end
end
