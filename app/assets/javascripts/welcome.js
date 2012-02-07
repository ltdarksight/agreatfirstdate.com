$(function () {
  $(".select_box").selectbox();

  //Welcome toggler
  $('#login_link').click(function() {
    $('#welcomeLogin').toggle();
    return false;
  });
});

