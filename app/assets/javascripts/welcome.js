$(function () {
  $(".select_box").selectbox();
});

$(function() {
  var passwordField = $('input[type="password"]');

  passwordField.after('<input id="passwordPlaceholder" type="text" value="Password" autocomplete="off" />');
  var passwordPlaceholder = $('#passwordPlaceholder');

  passwordPlaceholder.show();
  passwordField.hide();

  passwordPlaceholder.focus(function() {
    passwordPlaceholder.hide();
    passwordField.show();
      passwordField.focus();
  });

  passwordField.blur(function() {
    if(passwordField.val() == '') {
      passwordPlaceholder.show();
      passwordField.hide();
    }
  });

});

