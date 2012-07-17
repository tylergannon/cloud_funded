$ ->
  $('.click_to_upload').live 'click', (e) ->
    $el = $(e.target)
    field = $el.parent().data('field')
    $('#' + field).click()
    e.preventDefault()
    
  $('.file_uploads input[type=file]').each (index, el) ->
    $el = $ el
    field = $el.attr('id')
    console.log("The field is " + field)
    $('#' + field).html5_upload
      url: (number) ->
        $('.file_uploads').data('action')
        # $('#project_image_form').attr('action')
      fieldName: 'project[' + field + ']'
      sendBoundary: window.FormData or $.browser.mozilla
      onStart: (event, total) ->
        $('.upload_status').show()
        return true
        # confirm "You are trying to upload " + total + " files. Are you sure?"

      # onProgress: (event, progress, name, number, total) ->
      #   $('.upload_status').html('%' + progress.toString())
      #   console.log progress, number
      # 
      # setName: (text) ->
      #   $("#progress_report_name").text text
      # 
      # setStatus: (text) ->
      #   $("#progress_report_status").text text

      # setProgress: (val) ->
      #   $('.upload_status').html('%' + val.toString())
      #   # $("#progress_report_bar").css "width", Math.ceil(val * 100) + "%"

      onFinishOne: (event, response, name, number, total) ->
        console.log("The field still is " + field)
        image_url = JSON.parse(response)[field].url_large
        the_image = $('#' + field + '_tag')
        the_image.attr('src', image_url)
        the_image.show()
        $('#' + field + '_placeholder_tag').hide()
        $('#change_' + field + '_tag').show()
        
        # $('div.project_image').html('<img src=\"' + image_url + '\" alt=\"Project Image\" id=\"project_image_tag\"><\/img>')
        $('.upload_status').hide()
        console.log image_url

      onError: (event, name, error) ->
        alert "error while uploading file " + name
