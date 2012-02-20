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
//= require jquery-ui
//= require jquery_ujs
//= require jquery.form
//= require jquery.remotipart
//= require underscore
//= require backbone
//= require backbone_rails_sync
//= require backbone_datalink
//= require backbone.validations
//= require backbone/agreatfirstdate
//= require jcrop
//= require_tree .


$(function() {
  Common.init();

  var page = $("body").data("page");
  if("object" === typeof window[page])
    window[page].init();
});

jQuery.fn.extend( {
  outerHtml: function( replacement )
  {
    // We just want to replace the entire node and contents with
    // some new html value
    if (replacement)
    {
      return this.each(function (){ $(this).replaceWith(replacement); });
    }

    /*
     * Now, clone the node, we want a duplicate so we don't remove
     * the contents from the DOM. Then append the cloned node to
     * an anonymous div.
     * Once you have the anonymous div, you can get the innerHtml,
     * which includes the original tag.
     */
    var tmp_node = $("<div></div>").append( $(this).clone() );
    var markup = tmp_node.html();

    // Don't forget to clean up or we will leak memory.
    tmp_node.remove();
    return markup;
  }
});

/*
* DO NOT place any code here.
* Code that should run on specific page goes to ControllerView function in appropriate file (e.g. CitiesIndex)
* Common code goes to Common function in this file
*/

