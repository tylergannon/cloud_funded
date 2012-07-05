# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $('.project').each (idx, el) ->
    $el = $(el)
    $el.click ->
      window.location.href = $el.data('project-path')
    
  $('.progress').each (idx, el) ->
    $el = $(el)
    $el.progressbar
      value: $el.data('percent-complete')
      
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

geocodeHandler = (results, status) ->
  if status is google.maps.GeocoderStatus.OK
    map.setCenter results[0].geometry.location
    if window.marker != undefined
      window.marker.setVisible(false)
    window.marker = new google.maps.Marker
      map: window.map
      position: results[0].geometry.location
    window.address = results[0]
    $('#answer').html('Ahhh.  ' + getLocality(results[0]) + '.')
    $('#project_address').val(results[0].formatted_address)
    $('#project_lat').val(results[0].geometry.location.lat())
    $('#project_long').val(results[0].geometry.location.lng())
  else
    $('#answer').html('Hmmmm, couldn\'t look that up.' +  status)

getLocality = (address) ->
  component = switch address.types[0]
    when "street_address" then 2
    when "postal_code" then 1
    when "locality" then 0
    when "administrative_area_level_1" then 0
    else 0
  address.address_components[component].long_name

codeAddress = ->
  address = $("#project_address").val()
  window.geocoder.geocode
    address: address
  , geocodeHandler

