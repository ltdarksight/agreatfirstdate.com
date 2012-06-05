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
})

