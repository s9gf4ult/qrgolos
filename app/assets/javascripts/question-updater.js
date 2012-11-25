$(function() {
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
        timer.html('');
        timer.hide();
        counting = false;
      }
      timer = $('#timer');
      if (! counting) {
        question = data.question;
        if (question) {
          if (question.countdown_remaining) {
            timer.show(); // показать элемент
            timer.html(question.countdown_remaining);
            counting = true;
            timer.delay(1000).queue(function() {
              counting = false;
              redraw_timer();
            }).dequeue();
          } else {
            hide(timer);
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
    launch_faye_updater(window.QUESTION_CHANNEL, regenerate_screen);
    launch_faye_updater(window.VOTE_CHANNEL, regenerate_screen);
});


