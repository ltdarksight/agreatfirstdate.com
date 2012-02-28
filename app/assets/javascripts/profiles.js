$(function(){
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
  $('.profiles.edit .datepicker').datepicker({changeYear: true, defaultDate: "-18y"})
})

var H = 0;
var pillarH = $('.pillar-content').height();

var pillarDynamic = function(){   
    $(".top_row").each(function(i){
        var h = $("div").eq(i).height();
        if(h > H) H = h - 180;
    });
    $(".span_first_pillar .pillar-box").height(H);
};
 
$(document).ready(pillarDynamic);
$(window).resize(pillarDynamic);

