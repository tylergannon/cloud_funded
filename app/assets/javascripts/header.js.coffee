$ ->
  $('.page_title').click ->
    window.location.href = '/'
  $('.my_controls .no_controls_list a.show').click ->
    $('.no_controls_list').hide()
    $('.control_list').show()
  $('.my_controls .control_list a.hide').click ->
    $('.no_controls_list').show()
    $('.control_list').hide()
