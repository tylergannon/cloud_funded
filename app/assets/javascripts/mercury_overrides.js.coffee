$ ->
  $(window).on 'mercury:ready', ->
    Mercury.saveUrl = $('.mercury_container').data('save-url');
    $('form.edit_page').hide()
    $('#edit_link').hide()
    $('.page img').resizable
      aspectRatio: true

    $('a').click (a) ->
      unless $(a).attr('href').match(/^\#/)?
        unless confirm('Do you want to leave this page?  Be sure you have saved changes.')
          a.preventDefault()
    
    Mercury.config.uploading.url = window.location.href.replace('/editor', '').split('?')[0] + '/attachments';
    Mercury.config.uploading.inputName = 'attachment[image]'
    Mercury.config.uploading.allowedMimeTypes = ['image/jpeg', 'image/gif', 'image/png', 'image/bmp']
    
    Mercury.debug = true

    Mercury.on 'saved', ->
      window.parent.parent.window.location = window.parent.parent.window.location.href.replace(/\/editor\//i, '/');
