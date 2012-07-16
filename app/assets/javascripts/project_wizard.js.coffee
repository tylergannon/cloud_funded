$ ->
  $('#project_image_tag').live 'click', (e) ->
    $('#project_image').click()
    e.preventDefault()

  $('#project_image').html5_upload
    url: (number) ->
      $('#project_image_form').attr('action')
    fieldName: 'project[image]'
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
      image_url = JSON.parse(response).image.url_large
      $('div.project_image').html('<img src=\"' + image_url + '\" alt=\"Project Image\" id=\"project_image_tag\"><\/img>')
      $('.upload_status').hide()
      console.log image_url

    onError: (event, name, error) ->
      alert "error while uploading file " + name
