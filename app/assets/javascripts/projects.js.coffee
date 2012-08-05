# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  # $('#tabs').tabs()
  $('#tabs ul.nav-tabs a').click (e) ->
    e.preventDefault()
    $(this).tab('show')
  
  
  $('input.date').each ->
    $this = $(this)
    $this.wrap("<div class='input-prepend'>")
    $this.before("<span class='add-on'><i class='icon icon-th'/></span>")
  $('input.number').each ->
    $this = $(this)
    $this.wrap("<div class='input-prepend'>")
    $this.before("<span class='add-on'><i class='icon icon-resize-vertical'/></span>")

  $('input.money').money_field()
  $('.project').each (idx, el) ->
    $el = $(el)
    $el.click ->
      window.location.href = $el.data('project-path')
    
  fbResponse = (response) ->
    if not response or response.error
      alert "Error occured"
    else
      alert "Created project!: " + response.id
      
  askForSupport = ->
    FB.api "/me/#{AppConfig.opengraph_namespace}:create", "post",
      project: $('#project_url').attr('content'), 
      fbResponse
      
  createProject = ->
    FB.api "/me/#{AppConfig.opengraph_namespace}:create", "post",
      project: $('#project_url').attr('content'), 
      fbResponse
  
  $('#create_on_facebook').click ->
    createProject()
  
  $('#project_short_description').keyup ->
    $('#char_count').html (250 - $('#project_short_description').val().length)
    
  $('#project_address').focusout ->
    codeAddress()

  $('#check_address').click (e) ->
    e.preventDefault()
    codeAddress()

  if $('#map_canvas').length > 0
    initialize()
    
firstLookup = true

initialize = ->
  window.geocoder = new google.maps.Geocoder()
  latlng = new google.maps.LatLng(37.852437, -122.274392)
  myOptions =
    scrollwheel: false
    navigationControl: true
    mapTypeControl: false
    scaleControl: false
    draggable: false
    zoom: 12
    center: latlng
    mapTypeId: google.maps.MapTypeId.ROADMAP

  window.map = new google.maps.Map(document.getElementById("map_canvas"), myOptions)
  window.marker = undefined
  if $('#project_address').val().length > 0
    codeAddress()
  else
    createAnswerField()

geocodeHandler = (results, status) ->
  if status is google.maps.GeocoderStatus.OK
    map.setCenter results[0].geometry.location
    if window.marker != undefined
      window.marker.setVisible(false)
    window.marker = new google.maps.Marker
      map: window.map
      position: results[0].geometry.location
    window.address = results[0]

    for address_component in address.address_components
      do (address_component) ->
        switch address_component.types[0]
          when "administrative_area_level_1" then type = 'state'
          when "administrative_area_level_2" then type = 'county'
          when "locality"                    then type = 'city'
          else type = address_component.types[0]
        $('#project_' + type).val(address_component.short_name)
    
    $('#project_address').val(results[0].formatted_address)
    $('#project_lat').val(results[0].geometry.location.lat())
    $('#project_long').val(results[0].geometry.location.lng())
    $('#answer').html('Ahhh.  ' + $('#project_city').val() + '.') if $('#project_city').val()?
  else
    $('#answer').html('Hmmmm, couldn\'t look that up.' +  status)
  createAnswerField()

createAnswerField = ->
  $('#answer_wrapper').append('<div id="answer"></div>') unless $('#answer').length
codeAddress = ->
  address = $("#project_address").val()
  window.geocoder.geocode
    address: address
  , geocodeHandler

