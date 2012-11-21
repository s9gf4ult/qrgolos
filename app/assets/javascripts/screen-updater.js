//= require faye-updater.js

function update_screen() {
    window.location.reload();
}

$(function () {
    launch_faye_updater(window.SCREEN_CHANNEL, update_screen)
})
