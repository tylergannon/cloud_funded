$ ->
  $(document).on 'click', '.click_to_upload:visible', (e) ->
    $el = $(e.target)
    console.log $el.attr('class')
    field = $el.parent().data('field')
    console.log("fuck off" + field)
    $('#' + field).click()
    e.preventDefault()

  resetHtml5Uploads()
    
  $(document).on 'js_loaded', 'body', (e) ->
    resetHtml5Uploads()
    
  window.currentDaysCount = () ->
    parseInt $('#project_days').val()
  window.getStartDate = () ->
    new Date($('#project_start_date').val())
  window.setStartDate = (date) ->
    $('#project_start_date').val('' + (date.getMonth() + 1) + '/' + date.getDate() + '/' + date.getFullYear())
  window.getEndDate = () ->
    new Date($('#project_end_date').val())
  window.setEndDate = (date) ->
    $('#project_end_date').val('' + (date.getMonth() + 1) + '/' + date.getDate() + '/' + date.getFullYear())
  
  $('#project_start_date').change ->
    startDate = getStartDate()
    startDate.setDate(startDate.getDate() + currentDaysCount())
    setEndDate(startDate)

  console.log('awesome')

  $('#project_end_date').change ->
    startDate = getStartDate()
    console.log(startDate)
    endDate = getEndDate()
    console.log(endDate)
    console.log(endDate - startDate)
    $('#project_days').val Math.round((endDate - startDate) / (1000*60*60*24))

  $('#project_days').change ->
    startDate = getStartDate()
    startDate.setDate(startDate.getDate() + currentDaysCount())
    setEndDate(startDate)

resetHtml5Uploads = () ->  
  $('.file_uploads input[type=file]').each (index, el) ->
    $el = $ el
    field = $el.attr('id')
    $('#' + field).html5_upload
      url: (number) ->
        $el.parent().data('action')
        # $('#project_image_form').attr('action')
      fieldName: $('.file_uploads').data('form-field-name') ? 'project[' + field + ']'
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
