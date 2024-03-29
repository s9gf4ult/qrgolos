module ApplicationHelper
  def meeting_owner?(meeting)
    user_signed_in? and meeting.user == current_user
  end

  def section_owner?(section)
    meeting_owner?(section.meeting) #  FIXME: Here must be check of section
  end

  def broadcast(channel, data = nil)
    message = {:channel => channel, :data => data}
    uri = URI.parse(Settings.faye.local_address)
    Net::HTTP.post_form(uri, :message => message.to_json)
  end

  def section_new_twitt_channel(section)
    "/sections/#{section.id}/twitts/new"
  end

  def section_twitts_activated_channel(section)
    "/sections/#{section.id}/twitts/activated"
  end

  def section_question_changed_channel(section)
    "/sections/#{section.id}/question/changed"
  end
  
  def screen_update_channel(screen)
    sid = if screen.is_a? Screen; then screen.id else screen end
    "/screens/#{sid}/update"
  end

  def section_new_votes_channel(section)
    "/sections/#{section.id}/votes/new"
  end

  def comet_section_twitts_activated(section) # 
    broadcast section_twitts_activated_channel(section)
  end

  def comet_section_new_votes(section) # 
    broadcast section_new_votes_channel(section)
  end

  def comet_section_new_twitt(section) # 
    broadcast section_new_twitt_channel(section)
  end
  
  def comet_section_question_changed(section) # 
    broadcast section_question_changed_channel(section)
  end

  def comet_screen_update(screen) # 
    broadcast screen_update_channel(screen)
  end

  def activate_section_twitt(twitt)
    tid = if twitt.is_a?(Twitt); then twitt.id else twitt end
    "/sections/twitt/#{tid}/activate"
  end

  def section_archive_name(section)
    "section-#{section.id}.zip"
  end

  def section_archive_path(section)
    "/files/#{section_archive_name(section)}"
  end

  def remove_section_archive(section)
    archname = "#{Rails.root}/public/#{section_archive_path(section)}"
    FileUtils.rm archname if File.exists? archname
  end

  def enqueue_archive_generation(section)
    if section.is_a? Section 
      Resque.enqueue(QrcodeImages, section.id)
    else
      Resque.enqueue(QrcodeImages, section)
    end
  end
end
