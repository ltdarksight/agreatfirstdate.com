//function editEventPopup(event_id) {
//  $('#edit_event_lightbox').dialog({
//    title: "Edit Event",
//    modal: true,
//    autoOpen: true,
//    height: 480,
//    width: 640,
//    open: function() {
//      //display dialog content
//      $(this).load("/event_items/"+event_id+"/edit.html", function() {
//        $("#edit_event_lightbox .datepicker").datepicker()
//      }).empty();
//    },
//    close: function() {
//      $(this).empty()
//    },
//    buttons: {
//      "Submit": function() {
//        $(this).find('form').submit();
//      },
//      "Cancel": function() {
//        $(this).dialog('close');
//      }
//    }
//  });
//}

$(function(){
  $("#datepicker").datepicker();
//	$(".add-event-link_").bind('click', function(event){
//		event.preventDefault();
//		$("#add_event_lightbox").dialog({
//      title: "Add Event",
//			height: 480,
//			width: 640,
//      resizable: false,
//      draggable: false,
//      modal: true,
//      buttons: {
//        "Submit": function() {
//          $("#new_event_item").submit();
//        },
//        "Cancel": function() {
//          $(this).dialog('close');
//        }
//      },
//      open: function() {
//        //display dialog content
//        $(this).find('#event_item_event_type_id, #event_type_fields').empty();
//      }
// 		});
//    $('#event_item_pillar_id').val($(this).attr('data_pillar_id')).trigger('change');
//	})

	$("#add_avatar_link").bind('click', function(event){
		event.preventDefault();
		$("#new_avatar_lightbox").dialog({
      height: 240,
      width: 480,
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
        "Upload": function() {
         $("#add_avatar_form").submit();
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
  $(".open-pillars-lightbox_").bind('click', function(){
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

$(function(){
  function set_dialog(selector, link) {
    $(selector).dialog({
      width: 480,
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
      buttons: [ 
        {
          text:link,
          click: function() {
              $(".profile:last").submit();
          }
        }
      ]
    });
  };

  $("#open_meet_lightbox").bind('click', function(){
    $("#profile_who_meet").limit('500','#charsToInput');
    set_dialog('#whom_lightbox', "I would like to meet");
    return false;
  })

  $("#open_who_lightbox").bind('click', function(){
    $("#profile_who_am_i").limit('500','#charsLeft');
    set_dialog('#who_lightbox', "That is me");
    return false;
  })
});