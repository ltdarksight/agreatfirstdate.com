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
    },

    heightWrapping: function () {
      var mHeight = $('#wrapper').height();
      mHeight = mHeight - 142;
      $('#pageContainer').height(mHeight);
      arraysHeight = mHeight - 30;
      $('#leftPillarArray, #rightPillarArray').height(arraysHeight);
      pillarsHeight = arraysHeight - 193;
      $('#leftMiddleBottomContainer').height(pillarsHeight);
    }
  };
  return self;
};
