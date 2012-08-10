$('#processing').modal('hide')
bootbox.alert '<%= "Notice: #{flash[:notice]}#{flash[:alert].blank? ? '' : '<br/>Error:' + flash[:alert]}".html_safe %>', ->
  if <%= @transaction.persisted? %>
    window.location.href = '<%= new_project_pledge_path(@project.to_param, :share) %>'
<% flash.clear %>