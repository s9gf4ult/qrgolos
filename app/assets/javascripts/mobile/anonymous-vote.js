//= require jquery
//= require mobile/jquery.mobile-1.2.0
//= require faye-updater
//= require mobile/mobile
//= require_self


function refresh_window() {
    window.location.reload();
}

$(function() {
    var client = make_faye_client()
    faye_subscribe(client, window.VOTE_CHANNEL, refresh_window);
});
