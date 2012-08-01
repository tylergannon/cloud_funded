$flash = $('<%= escape_javascript(render partial: "shared/flash_message", locals: {type: type, message: message}) %>')
$('body').append $flash
$flash.alert()
$flash.on 'closed', () ->
  $flash.remove()
