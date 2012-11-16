module ApplicationHelper
  def meeting_owner?(meeting)
    user_signed_in? and meeting.user == current_user
  end

  def section_owner?(section)
    meeting_owner?(section.meeting) #  FIXME: Here must be check of section
  end

  def broadcast(channel, &block)
    message = {:channel => channel, :data => capture(&block)}
    uri = URI.parse(Settings.faye.address)
    Net::HTTP.post_form(uri, :message => message.to_json)
  end

  def section_new_twitt_channel(session)
    section_channel "/sections/#{section.id}/twitts/new"
  end
end
