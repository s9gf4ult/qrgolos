
function refresh_window() {
    window.location.reload();
}

$(function() {
    launch_faye_updater(window.VOTE_CHANNEL, refresh_window);
});
