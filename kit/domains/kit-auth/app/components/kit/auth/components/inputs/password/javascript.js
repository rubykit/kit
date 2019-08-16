$(function() {

  const component_name     = "component_inputs_password";
  const component_selector = `.${component_name}`;
  const $components        = $(component_selector);

  $components.each(function() {
    setupComponent($(this));
  });

  function setupComponent($component) {
    if ($component.data('allow-visible') == false)
      return;

    const $input             = $component.find('input[type="password"]');
    const $visibility_toggle = $component.find('i.password_visibility');

    $visibility_toggle.show();
    hide();

    function show() {
      $input.attr({ type: 'text' });
      $visibility_toggle.removeClass('fa-eye');
      $visibility_toggle.addClass('fa-eye-slash');
    };

    function hide() {
      $input.attr({ type: 'password' });
      $visibility_toggle.removeClass('fa-eye-slash');
      $visibility_toggle.addClass('fa-eye');
    }

    let visible = false;
    $visibility_toggle.click(function() {
      visible = !visible;

      if (visible)
        show();
      else
        hide();
    });

  }

});