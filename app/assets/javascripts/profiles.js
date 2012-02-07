$(function(){
	
	$("#add_avatar_link").bind('click', function(event){
		event.preventDefault();
		$("#new_avatar_lightbox").dialog();
	})
	
})

var ProfilesMe = new function() {
  var self = {
    init: function () {
     Common.heightWrapping();
    }
  };
  return self;
};

$(function(){
  var dHeight = $(window).height();
  var dWidth = $(window).width();
  var dHeight = dHeight * 0.9;
  var dWidth = dWidth * 0.9;
  $("#open_pillars_lightbox").bind('click', function(){
    $("#pillars_lightbox").dialog({
      closeText: '',
      height: dHeight,
      width: dWidth,
      resizable: false,
      draggable: false,
      modal: true,
      buttons: {
        "Im ready": function() {
        },
        "Cancel": function() {
          $(this).dialog('close');
        }
      }
    });
    return false;
  })
});

