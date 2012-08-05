# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  if $('#sort_perks').length
    $('#sort_perks').sortable
      stop: ->
        order = _.map $('#sort_perks').children(), (el) ->
          "order[]=" + $(el).data('id')
        action = $('#sort_perks').data('save_url')
        $.post action, order.join('&')
