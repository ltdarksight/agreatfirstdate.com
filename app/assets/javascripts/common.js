var Common = new function() {
  var self = {
    init: function() {
        _.delay(function(){ $(".alert-error").fadeOut(2000)}, 8000)
        _.delay(function(){ $(".alert-success").fadeOut(2000)}, 10000)
    }
  };
  return self;
};
