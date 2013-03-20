var Common = new function() {
  var self = {
    init: function() {
      // flash boxes
      $(".alert-error").delay(8000).fadeOut(2000);
      $(".alert-success").delay(10000).fadeOut(2000);
    }
  };
  return self;
};
