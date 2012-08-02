jQuery ->
  $("a[rel=popover]").popover()
  $(".tooltip").tooltip()
  $("a[rel=tooltip]").tooltip()
  
$ ->
  $.rails.confirm = (message) ->
    $("#confirm_dialog > .modal-body").html("<p><i class='icon-warning-sign'></i> " + message + '</p>')
    false
  if $('[data-confirm]')
    $('body').append("<div class='modal hide' id='confirm_dialog'><div class='modal-header'><a class='close' data-dismiss='modal'>×</a><h3>" + I18n.t('confirm.title') + "</h3></div><div class='modal-body'></div><div class='modal-footer'><a class='btn btn-primary'></a><a href='#' data-dismiss='modal' class='btn'>" + I18n.t('confirm.cancel') + "</a></div></div>")
    $('[data-confirm]').each ->
      link_elem = $(this)
      link_elem.click (e) ->
        e.preventDefault()
        confirm = $('#confirm_dialog > .modal-footer > .btn-primary')
        new_confirm = link_elem.clone()
        new_confirm.removeAttr('data-confirm id')
        new_confirm.attr('class', 'btn btn-primary')
        new_confirm.html(I18n.t('confirm.ok'))
        confirm.replaceWith(new_confirm)
        $('#confirm_dialog').modal()
