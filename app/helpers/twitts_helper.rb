module TwittsHelper
  def comet_session_new_twitt(section)
    broadcast session_new_twitt_channel(section)
  end
end
