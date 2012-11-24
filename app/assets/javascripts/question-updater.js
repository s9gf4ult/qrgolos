$(function() {
  var counting = false;

    function question_generator(data) {
        question = data.question
        if (question) {
            timer_generator(data);
            variants = data.answer_variants
            cont = $('#content');
            cont.html('<div class="formHeader">' + question.question + '</div>')
            $.each(variants, function(i, aw) {
              cont.append('<div class="answer_variant" style="margin-right: 4em;">' +
              '<div class="variant_text"> &mdash;' + aw.text + '</div>' + '<br /></div>');
            })

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
    function regenerate_question() {
        $.get($(location).attr('href'), null, question_generator, "json");
    }
    regenerate_question();
    launch_faye_updater(window.QUESTION_CHANNEL, regenerate_question);
});


