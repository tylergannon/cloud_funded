$ ->
  $('.click_to_upload').live 'click', (e) ->
    $el = $(e.target)
    field = $el.parent().data('field')
    $('#' + field).click()
    e.preventDefault()
    
  $('.file_uploads input[type=file]').each (index, el) ->
    $el = $ el
    field = $el.attr('id')
    $('#' + field).html5_upload
      url: (number) ->
        $el.parent().data('action')
        # $('#project_image_form').attr('action')
      fieldName: $('.file_uploads').data('field') ? 'project[' + field + ']'
      sendBoundary: window.FormData or $.browser.mozilla
      onStart: (event, total) ->
        $('.upload_status').show()
        return true

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
  window.currentDaysCount = () ->
    parseInt $('#days input').val()
  window.getStartDate = () ->
    new Date($('#start_date input').val())
  window.setStartDate = (date) ->
    $('#start_date input').val('' + (date.getMonth() + 1) + '/' + date.getDate() + '/' + date.getFullYear())
  window.getEndDate = () ->
    new Date($('#end_date input').val())
  window.setEndDate = (date) ->
    $('#end_date input').val('' + (date.getMonth() + 1) + '/' + date.getDate() + '/' + date.getFullYear())
  
  $('#start_date input').change ->
    startDate = getStartDate()
    startDate.setDate(startDate.getDate() + currentDaysCount())
    setEndDate(startDate)

  $('#end_date input').change ->
    startDate = getStartDate()
    endDate = getEndDate()
    $('#days input').val((endDate - startDate) / (1000*60*60*24))

  $('#days input').change ->
    startDate = getStartDate()
    startDate.setDate(startDate.getDate() + currentDaysCount())
    setEndDate(startDate)
