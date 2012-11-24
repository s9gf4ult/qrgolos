$(function () {

    function twitts_generator(data) {
        cont = $('#content');
        // Generate statistics here
        cont.html('');          // очищаем конент
        $.each(data.twitts, function(i, twitt) {
            // twitt.name
            // twitt.text
            // twitt.time
            time = new Date(twitt.time);
            cont.append('<span>'+ twitt.text + time.getHours() + time.getMinutes() +'</span>');
        });
    }
    
    function redraw_twitts() {
        $.get($(location).attr('href'), null, twitts_generator, "json");
    }
    redraw_twitts();
    launch_faye_updater(window.TWITT_MODERATED_CHANNEL, redraw_twitts);
})


// <div class="formHeader">Чат: <%= @section.name %></div>
// <div id="twittTable">
// <% @section.active_twitts.limit(6).each do |twitt| %>
// <div class="twittMsg">
// <span class="tableName"><%= twitt.anonymous.formated_name %></span>:
// <div class="tableMsg"><%= twitt.text%></div>
// </div>
// <% end %>
// </div>
