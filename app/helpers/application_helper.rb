module ApplicationHelper
  def facebook_app_id
    ENV['FACEBOOK_APP_ID']
  end
  
  def og_tag(name, content)
    %(<meta property="#{name}" content="#{content}"/>).html_safe
  end
  
  PINTEREST_URL_BASE = %(http://pinterest.com/pin/create/button/?)
  def pinterest_url(project)
    PINTEREST_URL_BASE +
      {
        url: project_url(project),
        media: project.image.url(:original),
        description: project.tagline
      }.map{|key, val| "#{key}=#{u val}" }.join("&")
  end
  
  def pinterest_tag(project)
    link_to(pinterest_url(@project), class: 'pin-it-button', 'count-layout' => 'horizontal', target: '_blank') {
      image_tag '//assets.pinterest.com/images/PinExt.png', title: 'Pin It', border: 0      
    }.html_safe
  end
  
  def linkedin_tag(project)
    content_tag(:script, '', type: 'IN/Share', data: {url: project_url(project), counter: 'right'}).html_safe
  end
  
  def like_button(project)
    content_tag(:div, '', class: 'fb-like', data: {href: project_url(project), send: "false", width: 375, show_faces: "false"}).html_safe
  end
  
  def twitter_button(project)
    link_to('Tweet', 'https://twitter.com/share', class: 'twitter-share-button', data: {url: project_url(project), via: 'cloudfunded', hashtags: 'CrowdFunding'}).html_safe
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
