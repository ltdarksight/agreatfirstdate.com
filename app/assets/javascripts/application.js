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
//= require jquery-ui
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
//= require infiniScroll
//= require backbone-stripe
//= require agreatfirstdate
//= require_tree ../templates
//= require_tree ./models
//= require_tree ./collections
//= require_tree ./views
//= require_tree ./routers
//= require_tree .

$(function() {

  Common.init();
  $('#slides').superslides();
    $(".gender_select").ikSelect({
			  customClass: "gender_select",
			  ddCustomClass: "gender_select",
			  autoWidth: false
		});


});
//
// jQuery.fn.extend( {
//   outerHtml: function( replacement )
//   {
//     // We just want to replace the entire node and contents with
//     // some new html value
//     if (replacement)
//     {
//       return this.each(function (){ $(this).replaceWith(replacement); });
//     }
//
//     /*
//      * Now, clone the node, we want a duplicate so we don't remove
//      * the contents from the DOM. Then append the cloned node to
//      * an anonymous div.
//      * Once you have the anonymous div, you can get the innerHtml,
//      * which includes the original tag.
//      */
//     var tmp_node = $("<div></div>").append( $(this).clone() );
//     var markup = tmp_node.html();
//
//     // Don't forget to clean up or we will leak memory.
//     tmp_node.remove();
//     return markup;
//   }
// });
//
// (function($) {
//   return $.extend($.fn, {
//     backboneLink: function(model, options) {
//       options = $.extend({skip: []}, options);
//       return $(this).find(":input").each(function() {
//         var el, name;
//         el = $(this);
//         name = el.attr("name");
//         if (options.paramRoot) {
//           matches = name.match(new RegExp(options.paramRoot + "\\[([^\\]]+)\\]"));
//           if (matches) name = matches[1];
//         }
//         if (!_.include(options.skip, name)) {
//           model.bind("change:" + name, function() {
//
//             return el.val(model.get(name));
//           });
//         }
//
//         return $(this).bind("change", function() {
//           var attrs;
//           el = $(this);
//           attrs = {};
//           name = el.attr("name");
//           if (options.paramRoot) {
//             name = name.match(new RegExp(options.paramRoot + "\\[([^\\]]+)\\]"))[1]
//           }
//           attrs[name] = el.val();
//           return model.set(attrs);
//         });
//       });
//     }
//   });
// })(jQuery);
function hintFormatDate(date) {
  var shortMonthsInYear = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
  var d = new Date(date);
  return "<span class='day'>" + d.getDate() +"</span>" +
  ' '+ shortMonthsInYear[d.getMonth()] +
  ' '+ (d.getYear() - 100);
}
