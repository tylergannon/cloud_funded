$ ->
  $(window).on 'mercury:ready', ->
    # alert('nicebaz')
    Mercury.saveUrl = $('.mercury_container').data('save-url');
    $('form.edit_page').hide()
    $('#edit_link').hide()

    $('a').click (a) ->
      unless confirm('Do you want to leave this page?  Be sure you have saved changes.')
        a.preventDefault()
        
    # $('#mercury_iframe').attr('style', $('#mercury_iframe').attr('style') + 'overflow: scroll;')
    # $el = $(top.document.getElementById('mercury_iframe'))
    # $el.attr 'style', $el.attr('style') + 'overflow: scroll;'
    
    Mercury.config.uploading.url = window.location.href.replace('/editor', '').split('?')[0] + '/attachments';
    Mercury.config.uploading.inputName = 'attachment[image]'
    Mercury.config.uploading.allowedMimeTypes = ['image/jpeg', 'image/gif', 'image/png', 'image/bmp']
    
    Mercury.debug = true

    Mercury.on 'saved', ->
      window.parent.parent.window.location = window.parent.parent.window.location.href.replace(/\/editor\//i, '/');
  
    