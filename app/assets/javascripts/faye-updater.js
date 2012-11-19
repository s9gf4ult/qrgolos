//= require jquery

function launch_faye_updater(channel, callback) {
    $(function() {
        var client = new Faye.Client(FAYE_ADDRESS);
        var subscribe = client.subscribe(channel, callback);
    });
};
