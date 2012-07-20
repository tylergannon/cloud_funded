class @Mercury.CustomPageEditor extends @Mercury.PageEditor

  constructor: ->
    super

  save: ->
    $('#mercury_iframe').contents().find('.page .ui-wrapper').each (idx) ->
      $el = $(this)
      $img = $el.find('img')
      $img.removeClass('ui-resizable')
      $img.attr 'style', 'height: ' + $img.height() + 'px; width: ' + $img.width() + 'px;'
      $el.replaceWith $img

    super
    # data = @serialize()
    # Mercury.log('saving', data)
    # data = jQuery.toJSON(data) unless @options.saveStyle == 'form'
    # jQuery.ajax '/contents', {
    #   type: 'POST'
    #   data: {_method: 'PUT', content: data}
    #   success: =>
    #     Mercury.changes = false
    #   error: =>
    #     alert("Mercury was unable to save.")
    # }