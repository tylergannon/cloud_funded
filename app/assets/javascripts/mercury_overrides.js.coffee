$ ->
  $(window).on 'mercury:ready', ->
    Mercury.saveUrl = $('.mercury_container').data('save-url');
    $('form.edit_page').hide()
    $('#edit_link').hide()
    unless $('a.resizeImages').length
      $('.mercury-region[data-mercury=full]').before('<a href="#" title="Click To Resize Images, Click Again When Done" class="tippy resizeImages"><i class="icon icon-resize-full"/></a>')
      $('a.resizeImages').click (e) ->
        e.preventDefault()
        $a = $(this)
        $mercury_region = $a.next()
        if $mercury_region.data('resizing')
          $mercury_region.find('img').resizable('destroy')
          $mercury_region.data('resizing', false)
        else
          $mercury_region.find('img').resizable
            aspectRatio: true
          $mercury_region.data('resizing', true)
        
    $('a.tippy').tooltip()
    # $('.mercury-region').live 'focus', ->
    #   $(this).find('img').each ->
    #     $img = $(this)
    #     window.thing = $img
    #     console.log($img.resizable('widget')[0].tagName)
    #     if $img.resizable('widget')[0].tagName == 'IMG'
    #       $img.resizable
    #         aspectRatio: true

    $('a[href]').click (a) ->
      unless $(a).attr('href').match(/^\#/)?
        unless confirm('Do you want to leave this page?  Be sure you have saved changes.')
          a.preventDefault()
    
    Mercury.config.uploading.url = window.location.href.replace('/editor', '').split('?')[0] + '/attachments';
    Mercury.config.uploading.inputName = 'attachment[image]'
    Mercury.config.uploading.allowedMimeTypes = ['image/jpeg', 'image/gif', 'image/png', 'image/bmp']
    
    Mercury.debug = false

    Mercury.on 'saved', ->
      window.parent.parent.window.location = window.parent.parent.window.location.href.replace(/\/editor\//i, '/');
