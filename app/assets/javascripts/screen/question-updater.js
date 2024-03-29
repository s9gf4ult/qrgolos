//= require jquery
//= require screen/raphael
//= require faye-updater
//= require_self


$(function() {
    function update_screen() {
        window.location.reload();
    }
    
    // Raphael drawer
    var clock = document.getElementById('clock');
    
    var archtype = Raphael("timer", 200, 200);
    archtype.customAttributes.arc = function (xloc, yloc, value, total, R) {
        var alpha = 360 / total * value,
        a = (90 - alpha) * Math.PI / 180,
        x = xloc + R * Math.cos(a),
        y = yloc - R * Math.sin(a),
        path;
        if (total == value) {
            path = [
                ["M", xloc, yloc - R],
                ["A", R, R, 0, 1, 1, xloc - 0.01, yloc - R]
            ];
        } else {
            path = [
                ["M", xloc, yloc - R],
                ["A", R, R, 0, +(alpha > 180), 1, x, y]
            ];
        }
        return {
            path: path
        };
    };

    var my_arc = archtype.path().attr({
        "stroke": "#3B369D",
        "stroke-width": 50,
        arc: [70, 70, 100, 100, 30]
    });
    
    var counting = false;

    function draw_question(data) {
        variants = data.answer_variants
        cont = $('#content');
        cont.html('<div class="formHeader">' + question.question + '</div>')
        $.each(variants, function(i, aw) {
            cont.append('<div class="answer_variant" style="margin-right: 4em;">' +
                        '<div class="variant_text"> &mdash;' + aw.text + '</div>' + '<br /></div>');
        })
    }

    function draw_statistics(data) {
        cont = $('#content');
        question = data.question;
        variants = data.answer_variants;
        cont.html('<div class="formHeader">' + question.question + '</div>')
        $.each(variants, function(i, aw) {
            cont.append('<div class="answer_variant" style="margin-right: 4em;">' +
                        '<div class="variant_spacer">' +
                        '<div style="width: ' + aw.percent + '%" class="variant_strip" ></div>' +
                        '</div>' +
                        '<div class="variant_text">&nbsp;' + aw.text + '&nbsp;&mdash;&nbsp;' + Math.round(aw.percent*100)/100 + '%</div>' +
                        '<br />' +
                        '</div>');
        });
    }

    function screen_generator(data) {
        question = data.question
        if (question) {
            timer_generator(data);
            if (question.state == "showed") {
                draw_question(data);
            } else {
                draw_statistics(data);
            }
        } else {
            $('#content').html('<div class="formHeader">Ожидание голосования</div>');
        }
    }
    
    function timer_generator(data) {
      function hide(timer) {
      timer.hide();
      try {
	      clock.pause();
          clock.currentTime = 0;
      } catch (a) {
      };
      counting = false;
      }
      timer = $('#timer');
      if (! counting) {
        question = data.question;
        if (question) {
          if (question.countdown_remaining) {
            rem = question.countdown_remaining;
            if (! timer.is(':visible')) {
               clock.play();
            }
            timer.show(); // показать элемент
            my_arc.rotate(0, 50, 50).animate({ arc: [70, 70, (100/window.COUNTDOWN) * rem, 100, 30] }, 500, "bounce");
            counting = true;
            timer.delay(1000).queue(function() {
              counting = false;
              redraw_timer();
            }).dequeue();
          } else {
           // if (timer.is(':visible')) {
               // k boom.play();
           // }
            hide(timer);
            //boom.play(); //добавить проверку на наличие показанного таймера
          }
        } else {
          hide(timer);
        }
      }
    }

    function redraw_timer() {
      $.get($(location).attr('href'), null, timer_generator, "json");
    }
    function regenerate_screen() {
        $.get($(location).attr('href'), null, screen_generator, "json");
    }
    regenerate_screen();


    var client = make_faye_client()
    faye_subscribe(client, window.SCREEN_CHANNEL, update_screen);
    faye_subscribe(client, window.QUESTION_CHANNEL, regenerate_screen);
    faye_subscribe(client, window.VOTE_CHANNEL, regenerate_screen);
});


$(function() {
  $('#bannerImg').height($(window).height() * 0.86);
  $('#bannerImg').width($(window).height() * 1.3);
  $('#bannerImg').css("padding", $(window).height() * 0.05);

  $('#blocks').width($('#bannerImg').width() * 0.25 );
  $('#blocks > img').width($('#bannerImg').width() * 0.25);
  $('#HbannerI').width($('#bannerImg').width() * 0.25);

  $('#HbannerT').height($(window).height() * 0.0685);
  $('#HbannerT').css("padding-bottom", $(window).height() * 0.04);

  $('#HbannerQ').height($(window).height() * 0.0685);
  $('#HbannerQ').css("padding-bottom", $(window).height() * 0.04);

});
