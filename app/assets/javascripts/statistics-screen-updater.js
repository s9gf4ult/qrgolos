$(function () {

    function statistics_generator(data) {
        cont = $('#content');
        // Generate statistics here
    }
    
    function redraw_statistics() {
        $.get($(location).attr('href'), null, statistics_generator, "json");
    }
    redraw_statistics();
    launch_faye_updater(window.QUESTION_CHANNEL, redraw_statistics);
    launch_faye_updater(window.VOTE_CHANNEL, redraw_statistics);
})


// <% if @section.statistics_question %>
// <div class="formHeader"><%= @section.statistics_question.question %></div>
// <% @section.statistics_question.formated_answer_variants.each do |aw| %>
// <div class="answer_variant" style="margin-right: 4em;">
// <div class="variant_spacer">
// <div style="width: <%= aw[:percent] %>%" class="variant_strip" ></div>
// </div>
// <div class="variant_text"> <%= aw[:text] %> &mdash; <%= "#{aw[:percent].round 2} %" %></div>
// <br />
// </div>
// <% end %>
// <% else %>
// <div class="formHeader">Ожидание голосования</div>
// <% end %>
