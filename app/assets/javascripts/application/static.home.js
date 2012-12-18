//= require jquery
//= require jquery_ujs
//= require application/jquery.cycle.all.2.72.js
//= require application/Dialog
//= require application/Class
//= require application/qrgolos
//= require_self

$(document).ready(function() {
   $('#homeSlider').cycle({
      fx: 'cover', // выберите тип анимации, ex: fade, scrollUp, shuffle,...
      delay:    -2000,
      before: function(curr, next, opts) {
			opts.animOut.opacity = 0;
      },
      pager: '#homeSliderControls',

      pagerAnchorBuilder: function(idx, slide) {
      return '<a href="#"></a>';
    }
      });
});

$('#breadcrumbs-one').hide();
