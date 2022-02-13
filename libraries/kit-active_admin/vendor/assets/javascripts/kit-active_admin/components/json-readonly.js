;(function(window, $) {

  const initEditor  = function(i, container) {
    const $container = $(container);
    const $textarea  = $($container.find('textarea'));
    const options    = {
      modes: ['tree', 'text'],
      mode: 'view',
      onEditable: function (node) {
        if (!node.path) {
          return false;
        }
      },
    };
    let editor = new JSONEditor(container, options,JSON.parse($textarea.val()));

    let height;
    if (height = $textarea.data('height')) {
      $container.find('.jsoneditor').css('height', height)
    }

    editor.expandAll();
  }

  $(function() {
    $('.container_json_editor_readonly').each(initEditor);
  });

})(window, $);
