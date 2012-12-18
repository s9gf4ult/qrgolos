//= require jquery
//= require mobile/jquery.mobile-1.2.0
//= require mobile/faye-updater
//= require mobile/mobile
//= require_self

function regen_chat_list() {
    $.ajax({
        url: window.CHAT_URL,
        dataType: "json",
        success: function(data) {
            //data = data.reverse();
	    ul = $('#twitts_list');
	    ul.html('');
            $.each(data, function(i, el) {
	      li = $('<li data-corners="false" data-shadow="false" data-iconshadow="true" data-wrapperels="div" data-icon="arrow-r" data-iconpos="right" data-theme="c" class="ui-btn ui-btn-icon-right ui-li-has-arrow ui-li ui-btn-up-c">')
                //li.html('<h3>' + el.name + '</h3>' + '<p>' + el.text + '</p>');
		li.html('<div class="ui-btn-inner ui-li">' +
			  '<div class="ui-btn-text">' +
			  '<a href="#" class="ui-link-inherit">' + '<h3 class="ui-li-heading">' + el.name + '</h3>' +
			  '<p class="ui-li-desc">' + el.text + '</p>' + '</a>' +
			  '</div>' +
			'</div>');
                ul.append(li);
            });
            //$('#twitts_list').html(ul);
        }
    });
}

$(function() {
    regen_chat_list();
    var client = make_faye_client();
    faye_subscribe(client, window.TWITT_CHANNEL, regen_chat_list);

    $('#submit-twitt').click(function() {
      form = $('#new_twitt');
        if ($('#twitt-text').val().trim() != '') {
            $.post(form.attr('action'), form.serialize(),
                   function() {
                       $('#twitt-text').val('');
		       $('#post-twitt').popup('close');
                   });
	}
        //alert('Ваше сообщение отправлено на модерацию');
	return false;
    });

});
