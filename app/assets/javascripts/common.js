var Common = new function() {
  var self = {
    init: function() {
      // flash boxes
      $(".alert").delay(5000).fadeOut(2000);
      $(".select_box").selectbox();

      //Welcome toggler
      $('#login_link').click(function() {
        $('#welcomeLogin').toggle();
        return false;
      });
    }
  };
  return self;
};
