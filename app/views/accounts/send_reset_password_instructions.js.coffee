$.ajax
  url: '<%= destroy_member_session_path %>'
  type: 'delete'
  success: (data) ->
    alert("You have been logged out.  Please check your email for instructions.")
    window.location.href = '/'
