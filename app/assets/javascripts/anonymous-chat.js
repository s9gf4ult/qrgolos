//= require "faye-updater"

function regen_chat_list() {
    $.ajax({
        url: window.CHAT_URL,
        dataType: "json",
        success: function(data) {
            //data = data.reverse();
	    ul = $('#twitts_list');
	    ul.html('');
            $.each(data, function(i, el) {
                li = $('<li class="whideLi">')
                li.html('<span class="name_element">' + el.name + '</span>' + ': ' + '<span class="text">' + el.text + '</span>');
                ul.append(li);
            });
            //$('#twitts_list').html(ul);
        }
    });
}

$(function() {
    regen_chat_list();
    launch_faye_updater(window.TWITT_CHANNEL, regen_chat_list);

    $('#submit-twitt').click(function() {
        form = $('#twitt-form');
        if ($('#twitt-text').val().trim() != '') {
            $.post(form.attr('action'), form.serialize(),
                   function() {
                       $('#twitt-text').val('');
                   });
        }
        $('#twitt-form').attr('selected',false);
        return false;
    });
    
    $('#submit-name').click(function() {
      form = $('#name-form');
	       if ($('#name-text').val().trim() != '') {
		 $.post(form.attr('action'), form.serialize(),
			function() {
			  $('#name-text').val('');
			});
	       }
	       location.reload();
	       $('#name-form').attr('selected',false);
      return false;
    });
    
});
