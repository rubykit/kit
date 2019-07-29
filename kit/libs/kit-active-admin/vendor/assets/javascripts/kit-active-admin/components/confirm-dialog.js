// Missing the `rails.fire(element, 'confirm:complete', [answer])` logic

$(function() {
  $.rails.allowAction = function(element) {
    var attr_name, attr_value;
    attr_name = 'data-confirm';
    attr_value = element.attr(attr_name);
    if (!attr_value) {
      return true;
    }
    $.rails.showConfirmDialog(attr_value).then(function() {
      element.removeAttr(attr_name);
      element[0].click();
      return element.attr(attr_name, attr_value);
    });
    return false; // always stops the action since code runs asynchronously
  };
  return $.rails.showConfirmDialog = function(text) {
    return swal({
      title: text,
      input: 'text',
      inputPlaceholder: 'YES',
      showCancelButton: true,
      confirmButtonText: 'Confirm',
      confirmButtonColor: '#f0ad4e',
      allowOutsideClick: true,
      preConfirm: function(value) {
        return new Promise(function(resolve, reject) {
          if (value !== 'YES') {
            return reject('You must type YES to continue');
          } else {
            return resolve();
          }
        });
      }
    });
  };
});
