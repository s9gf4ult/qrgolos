//= require jquery
//= require faye-updater
//= require_self

$(function () {

    function update_screen() {
        window.location.reload();
    }

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
    
    var client = make_faye_client()
    faye_subscribe(client, window.SCREEN_CHANNEL, update_screen);
    faye_subscribe(client, window.TWITT_MODERATED_CHANNEL, redraw_twitts);
})


$(function() {
  $('#bannerImg').height($(window).height() * 0.86);
  $('#bannerImg').width($(window).height() * 1.3);
  $('#bannerImg').css("padding", $(window).height() * 0.05);

  $('#blocks').width($('#bannerImg').width() * 0.25 );
  $('#blocks > img').width($('#bannerImg').width() * 0.25);
  $('#HbannerI').width($('#bannerImg').width() * 0.25);

  $('#HbannerT').height($(window).height() * 0.0685);
  $('#HbannerT').css("padding-bottom", $(window).height() * 0.04);

  $('#HbannerQ').height($(window).height() * 0.0685);
  $('#HbannerQ').css("padding-bottom", $(window).height() * 0.04);

  $('#twittTable').width($('#bannerImg').width() * 0.6 + 15);
  $('.tableMsg').width($('#bannerImg').width() * 0.6);
});
