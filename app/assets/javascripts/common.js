var Common = new function() {
  var self = {
    init: function() {
      // flash boxes
      $(".alert-error").delay(5000).fadeOut(2000);
      $(".alert-success").delay(5000).fadeOut(2000);
      $(".select_box").selectbox();
    }
  };
  return self;
};
