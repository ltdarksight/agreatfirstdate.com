$(function(){
  $("#datepicker").datepicker();
	$(".add_new_event").bind('click', function(event){
		event.preventDefault();
		$("#add_event_lightbox").dialog({
			
			height: 480,
			width: 640,
      		resizable: false,
      		draggable: false,
      		modal: true,
      		buttons: {
        		"Submit": function() {
        			$("#addAnEvent").submit();
        		}
      		}
 		})
	})
	$("#add_avatar_link").bind('click', function(event){
		event.preventDefault();
		$("#new_avatar_lightbox").dialog({
			height: 240,
      		width: 480,
      		resizable: false,
      		draggable: false,
      		modal: true,
      		buttons: {
        		"Upload": function() {
        			$("#add_avatar_form").submit();
        		},
        		"Cancel": function() {
          			$(this).dialog('close');
        		}
      		}
		});
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
  $("#open_pillars_lightbox").bind('click', function(){
    $("#pillars_lightbox").dialog({
      width: 960,
      resizable: false,
      draggable: false,
      modal: true,
      open: function(event, ui){
        $('<a />', {
          'class': 'linkCancel',
          text: 'Cancel',
          href: ''
        })
        .appendTo($(".ui-dialog-buttonpane"))
        .click(function(){
          $(event.target).dialog('destroy');
          return false;
        });
        $(".ui-dialog-titlebar").hide();
      },
      buttons: {
        "I'm ready": function() {
        	$("#select_pillars_form").submit();
        }
      }
    });
    return false;
  })
});
