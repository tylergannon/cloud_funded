$('#perk_<%= @perk.id %>').replaceWith('<%= escape_javascript render(partial: 'perk_for_editor', object: @perk) %>')
bootbox.alert('Perk was updated')