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
  
  def method_missing(meth, *args)
    meth = meth.to_s
    raise "I can't handle #{meth}" unless meth.match(/control_group_/)
    helper = meth.gsub(/control_group_/, '')
    "<div class='control-group'>
      #{label(args[0], :class => 'control-label')}
      <div class='controls'>
        #{send helper, *args}
      </div>
    </div>
    ".html_safe
  end
end
