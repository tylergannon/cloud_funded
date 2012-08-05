$('#perk_<%= @perk.id %>').replaceWith('<%= escape_javascript render(partial: 'edit') %>')

$("body").trigger( $.Event("js_loaded") ); 

