// all dialog buttons should close their parent dialog
$(document).on("mobileinit", function(){
	$.mobile.defaultPageTransition = "slide";
    $(".ui-dialog button").live("click", function() {
	    $("[data-role='dialog']").dialog("close");
    });

});
$(function(){
    $.mobile.ajaxEnabled = false;
});
