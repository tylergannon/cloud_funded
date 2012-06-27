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
      
  createProject = ->
    FB.api "/me/cloudfunded:create", "post",
      project: $('#project_url').attr('content'), 
      (response) ->
        if not response or response.error
          alert "Error occured"
        else
          alert "Created project!: " + response.id
  
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
    $('#project_address').val(results[0].formatted_address)
    $('#project_lat').val(results[0].geometry.location.lat())
    $('#project_long').val(results[0].geometry.location.lng())
  else
    alert "Geocode was not successful for the following reason: " + status

codeAddress = ->
  address = $("#project_address").val()
  window.geocoder.geocode
    address: address
  , geocodeHandler

