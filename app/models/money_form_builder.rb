class MoneyFormBuilder < ActionView::Helpers::FormBuilder
  def money_field(attribute, options={})
    options.symbolize_keys!
    options[:class] = options[:class] ? "#{options[:class]} money" : "money"
    options[:value] ||= object.send(attribute).blank? ? 0 : object.send(attribute).dollars.to_i
    text_field(attribute, options)
  end
  
  def formatted_date_field(attribute, options={})
    options.symbolize_keys!
    format = options.delete(:format) || '%m/%d/%Y'
    options[:class] = options[:class] ? "#{options[:class]} date" : "date"
    options[:value] ||= object.send(attribute).blank? ? "" : object.send(attribute).strftime(format)
    text_field(attribute, options)
  end
  
  def date_field(*args)
    formatted_date_field(*args)
  end
  
  def method_missing(meth, *args)
    options = args.last.kind_of?(Hash) ? args.last : {}
    label_text = options.delete(:label)
    label_args = [args[0]]
    label_args << label_text if label_text
    label_args << {class: 'control-label'}
    
    if popover = options.delete(:popover)
      options[:rel] = 'popover'
      options[:data] ||= {
        original_title: popover[:title] || args[0].to_s.titleize,
        content: popover[:content]}
      options[:data].merge! popover.slice(:placement, :trigger)
    end
    
    meth = meth.to_s
    raise "I can't handle #{meth}" unless meth.match(/control_group_/)
    helper = meth.gsub(/control_group_/, '')
    "<div class='control-group'>
      #{label(*label_args)}
      <div class='controls'>
        #{send helper, *args}
      </div>
    </div>
    ".html_safe
  end
end
