//= require "faye-updater"

function regen_chat_list() {
    $.ajax({
        url: window.CHAT_URL,
        dataType: "json",
        success: function(data) {
            data = data.reverse();
            ul = $('<ul />')
            $.each(data, function(i, el) {
                li = $('<li />')
                li.html('<span class="name_element">' + el.name + '</span>' + ' - ' + '<span class="text_element">' + el.text + '</span>');
                ul.append(li);
            });
            $('#twitts_list').html(ul);
        }
    });
}

$(function() {
    regen_chat_list();
    launch_faye_updater(window.TWITT_CHANNEL, regen_chat_list);
});
