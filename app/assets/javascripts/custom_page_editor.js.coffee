class @Mercury.CustomPageEditor extends @Mercury.PageEditor

  constructor: ->
    super

  save: ->
    $('#mercury_iframe').contents().find('.mercury-region .ui-wrapper').each (idx) ->
      $el = $(this)
      $img = $el.find('img')
      $img.removeClass('ui-resizable')
      $img.attr('width', $img.width())
      $img.attr('height', $img.height())
      $el.replaceWith $img
    super
