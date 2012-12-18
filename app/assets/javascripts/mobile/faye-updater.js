//= require jquery

function make_faye_client() {
    return new Faye.Client(FAYE_ADDRESS);
}

function faye_subscribe(client, channel, callback) {
    return client.subscribe(channel, callback);
}
