$(function() {
  return $(".panel").each(function() {
    var $content, $header, $panel;
    $panel = $(this);
    $header = $panel.find('h3');
    $content = $panel.find('.panel_contents');
    if ($panel.data('toggle') === 'closed') {
      $content.hide();
    }
    return $header.click(function() {
      return $content.slideToggle(0);
    });
  });
});

