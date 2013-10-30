// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require jquery.ui.core
//= require jquery.ui.widget
//= require jquery.ui.slider
//= require jquery.easing.1.3.js
//= require jquery.animate-enhanced.js
//= require jquery.superslides.js
//= require js-routes
//= require jquery.countTo.js
//= require spin
//= require jquery.spin.js
//= require jquery.ikSelect.min
//= require twitter/bootstrap
//= require bootstrap-datepicker
//= require jquery.remotipart
//= require jcrop
//= require jquery.jcarousel
//= require underscore
//= require underscore.inflection
//= require underscore.strings.js
//= require backbone
//= require libs/infiniScroll
//= require backbone.syphon
//= require backbone.poller.js
//= require accounting.js
//= require agreatfirstdate
//= require_tree ../templates
//= require_tree ./models
//= require_tree ./collections
//= require_tree ./views
//= require_tree ./routers
//= require video
//= require_tree .

$(function() {

  Common.init();
  $('#slides').superslides({
    slide_easing: 'easeInOutCubic',
    slide_speed: 800
  });
    $(".gender_select").ikSelect({
			  customClass: "gender_select",
			  ddCustomClass: "gender_select",
			  autoWidth: false
		});


    function popupCenter(url, width, height, name) {
        var left = (screen.width/2)-(width/2);
        var top = (screen.height/2)-(height/2);
        return window.open(url, name, "menubar=no,toolbar=no,status=no,width="+width+",height="+height+",toolbar=no,left="+left+",top="+top);
    }

    $("a.popup").click(function(e) {
        popupCenter($(this).attr("href")+'?popup=true', $(this).attr("data-width"), $(this).attr("data-height"), "authPopup");
        e.stopPropagation(); return false;
    });

});

function hintFormatDate(date) {
  var shortMonthsInYear = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
  var d = new Date(date);
  return "<span class='day'>" + d.getDate() +"</span>" +
  ' '+ shortMonthsInYear[d.getMonth()] +
  ' '+ (d.getYear() - 100);
}
