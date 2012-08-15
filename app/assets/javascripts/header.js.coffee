$ ->
  $('.page_title').click ->
    window.location.href = '/'
  $('.my_controls .no_controls_list a.show').click ->
    $('.no_controls_list').hide()
    $('.control_list').show()
  $('.my_controls .control_list a.hide').click ->
    $('.no_controls_list').show()
    $('.control_list').hide()

  changes = false
  $('input').change ->
    changes = true
    
  unless /Android|webOS|iPhone|iPad|iPod|BlackBerry/i.test(navigator.userAgent)
    $('#container').css('min-height', ($(document).height() - 220 - $('#banner').height()).toString() + 'px')

