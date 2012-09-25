# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

window.postToFeed = ->
  callback = (response) ->
    document.getElementById("msg").innerHTML = "Post ID: " + response["post_id"]
  obj =
    method: "feed"
    link: "http://cloudfunded.com/about"
    # picture: "http://fbrell.com/f8.jpg"
    # name: "Facebook Dialogs"
    # caption: "Reference Documentation"
    # description: "Using Dialogs to interact with users."

  FB.ui obj, callback