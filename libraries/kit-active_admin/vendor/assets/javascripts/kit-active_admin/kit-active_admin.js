//= require ./dependencies/lodash-4.17.4.js

//= require active_admin/base
//= require activeadmin_addons/all

//= require popper
//= require bootstrap

//= require ./dependencies/sweetalert2-6.11.1

//= require ./components/confirm-dialog
//= require ./components/panel
//= require ./components/json-readonly

$(function() {
  // Prevent accidental scrolling in number inputs
  return $(':input[type=number]').on('mousewheel', function(e) {
    return $(this).blur();
  });
});
