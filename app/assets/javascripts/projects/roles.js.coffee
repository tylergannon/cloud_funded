# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

window.openNewMemberDialog = (htm) ->
  $el = $(htm)
  $('body').append($el)
  $('#cancel_new_team_member').click () ->
    $el.dialog 'close'
    $el.dialog 'destroy'
  $el.dialog
    title: "Add A Team Member"
    resizable: false
