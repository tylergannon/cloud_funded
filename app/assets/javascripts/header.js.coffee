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
  # window.onbeforeunload = () ->
  #   if changes
  #     return confirm()
      # message = "Are you sure you want to navigate away from this page?\n\nYou have made changes that will not be saved.\n\nPress OK to continue or Cancel to stay on the current page.";
      # return !!confirm(message)
  