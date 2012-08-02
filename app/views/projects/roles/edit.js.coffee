$('#edit_role').remove()
$modal = $("<%= escape_javascript(render partial: 'edit') %>")
$('body').append($modal)
$modal.modal()
$modal.on 'hidden', ->
  $modal.remove()
