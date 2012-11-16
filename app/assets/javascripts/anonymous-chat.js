//= require jquery

$(function() {
    var client = new Faye.Client(FAYE_ADDRESS);
    var subscribe = client.subscribe(TWITT_CHANNEL, function(message) {
        window.location.reload(); //  FIXME: this is tupid
    });
})
