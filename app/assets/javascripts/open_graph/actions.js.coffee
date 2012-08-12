
$ ->
  $('.like').on 'click', (e) ->
    e.preventDefault()
    $this = $ this
    unless $this.data('disabled')?
      $.ajax 
        url: "https://graph.facebook.com/me/og.likes",
        type: 'POST',
        data:
          access_token: $this.data('access-token')
          object: $this.data('object-url')
        dataType: 'json'
        success: (data, textStatus, jqXHR) ->
          $this.data('disabled', true)
          createOpenGraphAction 'OpenGraph::Like', $this.data('object-type'), $this.data('object-id'), data.id
          $img = $this.find('img')
          $img.attr 'src', $img.attr('src').replace('.png', '-disabled.png')
          console.log('Got it!!!')
          console.log(data.id)

  $('.launch').on 'click', (e) ->
    e.preventDefault()
    $this = $ this
    unless $this.hasClass('disabled')
      createOpenGraphAction 'OpenGraph::Launch', $this.data('object-type'), $this.data('object-id'), '',
        success: (data, textStatus, jqXHR) ->
          $this.children().html('Launched!')
          $this.addClass('disabled')
        error: (jqXHR, textStatus, errorThrown) ->
          bootbox.alert(errorThrown)
          

createOpenGraphAction = (type, object_type, object_id, action_id, callbacks) ->
  $.ajax
    url: '/open_graph/actions.json'
    type: 'POST'
    data:
      open_graph_action:
        type: type
        graph_object_type: object_type
        graph_object_id: object_id
        action_id: action_id
    success: callbacks.success || ->
    error: callbacks.error || ->
