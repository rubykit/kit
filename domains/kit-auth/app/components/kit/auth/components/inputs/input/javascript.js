$(function() {

  const $input_components = $('[class*="component_inputs_"]');

  $input_components.each(function() {
    setupComponent($(this));
  });

  function setupComponent($component) {
    const $input = $component.find('input');

    $input.keydown(function() {
      $input.removeClass('is-invalid');
    });
  }

});