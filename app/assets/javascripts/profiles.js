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
})

var H = 0;
var pillarH = $('.pillar-content').height();

var pillarDynamic = function(){   
    $(".top_row").each(function(i){
        var h = $("div").eq(i).height();
        if(h > H) H = h - 170;
    });
    $(".span_first_pillar .standart-widget").height(H);
    $(".span_second_pillar .standart-widget").height(H - 291);
};
 
$(document).ready(pillarDynamic);
$(window).resize(pillarDynamic);

