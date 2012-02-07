var Common = new function() {
  var self = {
    init: function() {
      // flash boxes
      $(".notice").fadeOut(5000);
      $(".alert").fadeOut(5000);
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

