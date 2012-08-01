# # Place all the behaviors and hooks related to the matching controller here.
# # All this logic will automatically be available in application.js.
# # You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
#
popupCenter = (url, width, height, name) ->
  left = (screen.width / 2) - (width / 2)
  top = (screen.height / 2) - (height / 2)
  window.open url, name, "menubar=no,toolbar=no,status=no,width=" + width + ",height=" + height + ",toolbar=no,left=" + left + ",top=" + top

$ ->
  $('#link_dwolla').click ->
    $('#dwolla').height(500)
    $('#dwolla').modal()
  
  $("a.popup").click (e) ->
    popupCenter $(this).attr("href"), $(this).attr("data-width"), $(this).attr("data-height"), "authPopup"
    e.stopPropagation()
    false
