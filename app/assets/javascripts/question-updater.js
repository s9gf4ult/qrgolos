
$(function() {
    function question_generator(data) {
        question = data.question
        if (question) {
            variants = data.answer_variants
            cont = $('#content');
            cont.html('<div class="formHeader">' + question.question + '</div>')

            
        } else {
            $('#content').html('<div class="formHeader">Ожидание голосования</div>');
        }
    }
    
    function regenerate_question() {
        $.get($(location).attr('href'), null, question_generator, "json");
    }
    regenerate_question();
    launch_faye_updater(window.QUESTION_CHANNEL, regenerate_question);
});
    
// <% if @section.active_question %>
//   <div class="formHeader"><%= @section.active_question.question %></div>
//   <% @section.active_question.formated_answer_variants.each do |aw| %>
//     <div class="answer_variant" style="margin-right: 4em;">
//       <div class="variant_text"> &mdash; <%= aw[:text] %></div>
//       <br />
//     </div>
//   <% end %>
// <% else %>
//   <div class="formHeader">Ожидание голосования</div>
// <% end %>
    
