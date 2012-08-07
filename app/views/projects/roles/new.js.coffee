$('#new_role').remove()
$modal = $("<%= escape_javascript(render partial: 'new') %>")
$('body').append($modal)
$modal.modal()
$('#role_email_address').typeahead
  ajax:
    url: '<%= member_search_path %>.json'
    method: 'get'
    preDispatch: (query) ->
      q: query
    displayField: 'id'
  matcher: -> true
  highlighter: (item) ->
    findPartial(item)

$('#role_email_address').on 'change', () ->
  $this = $(this)
  val = $this.val()
  if val.match(/^\d+$/)
    $('#role_member_id').val(val)
    $this.parent().parent().hide()
    $this.val('')
    $partial = $(findPartial(val))
    $partial.prepend($('<a href="#" rel="tooltip"><i class="icon icon-remove-sign"/></a>'))
    $('#new_role .modal-body').prepend($partial)
    $('.search_result a').on 'click', () ->
      $(this).tooltip('hide')
      $('#role_member_id').val('')
      $('.search_result').remove()
      $('#email_address_controls').show()
    $('.search_result a').tooltip
      title: "Remove this selection."

$modal.on 'hidden', ->
  $modal.remove()

findPartial = (item) ->
  _.find( $("[data-provide='typeahead']").data().typeahead.ajax.data, (obj) ->
    obj.id == item).partial
