module ApplicationHelper
  def facebook_app_id
    ENV['facebook_app_id']
  end
  
  def og_tag(name, content)
    %(<meta property="#{name}" content="#{content}"/>).html_safe
  end

  def toast_flash
    response = ''
    if flash[:notice]
      response += %(<div class="toast notice">#{flash[:notice]}</div>)
    end
    if flash[:alert]
      response += %(<div class="toast alert">#{flash[:alert]}</div>)
    end
    response.html_safe
  end
  
  def element_id(model)
    model.class.underscore + "_#{model.id}" 
  end
  
  def attrs(object, additional={})
    if as = additional.delete(:as)
      class_name = as
    else
      class_name = object.class.name.underscore.gsub(/\//, '_')
    end
    additional[:id] =  "#{class_name}_#{object.id}"
    additional[:data] ||= {}
    additional[:data][:id] = object.id
    
    additional[:class] = additional[:class] ? "#{class_name} #{additional[:class]}" : class_name

    vals = []
    additional.each do |key, val|
      if val.kind_of?(Hash)
        val.each do |subkey, subval|
          vals << %(#{key}-#{subkey}='#{subval.to_s}')
        end
      else
        vals << %(#{key}='#{val.to_s}')
      end
    end
    puts vals.join(' ').inspect
    vals.join(" ")
    
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
