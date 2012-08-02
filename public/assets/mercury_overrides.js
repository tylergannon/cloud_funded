(function() {

  $(function() {
    return $(window).on('mercury:ready', function() {
      Mercury.saveUrl = $('.mercury_container').data('save-url');
      $('form.edit_page').hide();
      $('#edit_link').hide();
      if (!$('a.resizeImages').length) {
        $('.mercury-region[data-mercury=full]').before('<a href="#" title="Click To Resize Images, Click Again When Done" class="tippy resizeImages"><i class="icon icon-resize-full"/></a>');
        $('a.resizeImages').click(function(e) {
          var $a, $mercury_region;
          e.preventDefault();
          $a = $(this);
          $mercury_region = $a.next();
          if ($mercury_region.data('resizing')) {
            $mercury_region.find('img').resizable('destroy');
            return $mercury_region.data('resizing', false);
          } else {
            $mercury_region.find('img').resizable({
              aspectRatio: true
            });
            return $mercury_region.data('resizing', true);
          }
        });
      }
      $('a.tippy').tooltip();
      $('a[href]').click(function(a) {
        if ($(a).attr('href').match(/^\#/) == null) {
          if (!confirm('Do you want to leave this page?  Be sure you have saved changes.')) {
            return a.preventDefault();
          }
        }
      });
      Mercury.config.uploading.url = window.location.href.replace('/editor', '').split('?')[0] + '/attachments';
      Mercury.config.uploading.inputName = 'attachment[image]';
      Mercury.config.uploading.allowedMimeTypes = ['image/jpeg', 'image/gif', 'image/png', 'image/bmp'];
      Mercury.debug = false;
      return Mercury.on('saved', function() {
        return window.parent.parent.window.location = window.parent.parent.window.location.href.replace(/\/editor\//i, '/');
      });
    });
  });

}).call(this);
