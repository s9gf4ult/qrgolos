$(function () {

    function twitts_generator(data) {

        cont = $('#content');
        // Generate statistics here
        cont.html('');          // очищаем конент
        cont.html('<div class="formHeader">Чат: ' + data.section.name + '</div>')
        cont.append('<div id="twittTable">')
        $.each(data.twitts.reverse(), function(i, twitt) {
            // twitt.name
            // twitt.text
            // twitt.time
            time = new Date(twitt.time);
            mmm = ((time.getMinutes()<10?'0':'') + time.getMinutes());
            $('#twittTable').prepend('<div class="twittMsg">' +
            '<span class="tableName">'+ twitt.name + '</span><span class="showtime">' +
            time.getHours() + ':' + mmm + '</span>' +
            '<div class="tableMsg">' + twitt.text + '</div>' //+  +'</span>'
            );
            $('.tableMsg').width($('#bannerImg').width() * 0.6);
            $('#twittTable').width($('#bannerImg').width() * 0.6 + 15);
        });
    }

    function redraw_twitts() {
        $.get($(location).attr('href'), null, twitts_generator, "json");
    }
    redraw_twitts();
    launch_faye_updater(window.TWITT_MODERATED_CHANNEL, redraw_twitts);
})
