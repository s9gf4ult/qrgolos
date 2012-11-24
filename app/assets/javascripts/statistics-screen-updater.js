$(function () {
    var counting = false;

    function statistics_generator(data) {
        cont = $('#content');
        question = data.question
        if (question) {
            timer_generator(data);

            variants = data.answer_variants
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

    function redraw_statistics() {
        $.get($(location).attr('href'), null, statistics_generator, "json");
    }

    function redraw_timer() {
        $.get($(location).attr('href'), null, timer_generator, "json");
    }
    redraw_statistics();
    launch_faye_updater(window.QUESTION_CHANNEL, redraw_statistics);
    launch_faye_updater(window.VOTE_CHANNEL, redraw_statistics);
})



// <br />
// </div>
// <% end %>
// <% else %>
// <div class="formHeader">Ожидание голосования</div>







