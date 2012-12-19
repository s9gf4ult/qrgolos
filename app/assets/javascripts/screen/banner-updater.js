//= require jquery
//= require faye-updater
//= require_self

function update_screen() {
    window.location.reload();
}

$(function () {
    $('#bannerImg').height($(window).height() - 128);
    
    var client = make_faye_client()
    faye_subscribe(client, window.SCREEN_CHANNEL, update_screen)
})
