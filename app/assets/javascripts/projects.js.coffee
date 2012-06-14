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