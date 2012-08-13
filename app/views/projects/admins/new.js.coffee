$('#new_admin').remove()
$modal = $("<%= escape_javascript(render partial: 'new') %>")
$('body').append($modal)
$modal.modal()
$('#email_address').typeahead
  ajax:
    url: '<%= member_search_path %>.json'
    method: 'get'
    preDispatch: (query) ->
      q: query
    displayField: 'id'
  matcher: -> true
  highlighter: (item) ->
    findPartial(item)

$('#email_address').on 'change', () ->
  $this = $(this)
  val = $this.val()
  if val.match(/^\d+$/)
    $('#member_id').val(val)
    $this.parent().parent().hide()
    $this.val('')
    $partial = $(findPartial(val))
    $partial.prepend($('<a href="#" rel="tooltip"><i class="icon icon-remove-sign"/></a>'))
    $('#new_admin .modal-body').prepend($partial)
    $('#new_admin input[type=submit]').removeClass('disabled')
    $('.search_result a').on 'click', () ->
      $(this).tooltip('hide')
      $('#member_id').val('')
      $('.search_result').remove()
      $('#email_address_controls').show()
      $('#new_admin input[type=submit]').addClass('disabled')
    $('.search_result a').tooltip
      title: "Remove this selection."

$modal.on 'hidden', ->
  $modal.remove()

findPartial = (item) ->
  _.find( $("[data-provide='typeahead']").data().typeahead.ajax.data, (obj) ->
    obj.id == item).partial
