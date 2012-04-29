$(function(){
  $("a.back_link").on('click', function(){window.history.back();location.href="/searches";return false})

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
  $('.my_profile.edit .datepicker').datepicker({changeYear: true, defaultDate: "-18y"})
})

var H = 0;

var pillarDynamic = function(){
  $(".top_row").each(function(i){
      var h = $("div").eq(i).height();
      if(h > H) H = h - 180;
  });
  $("#leftPillarContainer").css('min-height', H - 22);
  $("#leftMiddlePillar").css('min-height',    H - 42 - $('#pillarAboutMe').outerHeight());
  $("#rightMiddlePillar").css('min-height',   H - 42 - $('#pillarAboutMePhoto').outerHeight());
  $("#rightPillar").css('min-height',         H - 42 - $('#pillarAboutMeMeet').outerHeight());
};

$(window).load(pillarDynamic);
$(window).resize(pillarDynamic);
