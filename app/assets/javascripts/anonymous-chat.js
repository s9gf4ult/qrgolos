//= require jquery

function regen_chat_list() {
    $.ajax({
        url: $(location).attr('href'),
        dataType: "json",
        success: function(data) {
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
    var client = new Faye.Client(FAYE_ADDRESS);
    var subscribe = client.subscribe(TWITT_CHANNEL, function(message) {
        regen_chat_list();
    });
});
