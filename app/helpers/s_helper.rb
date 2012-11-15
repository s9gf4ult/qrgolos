module SHelper
  def s_anonymous_path(anonymous)
    aid = if anonymous.is_a?(Anonymous); then anonymous.aid else anonymous end
    "/s/#{aid}"
  end

  def anonymous_full_path(anonymous)
    spath = s_anonymous_path(anonymous)
    if Settings.host.port
      port = ":#{Settings.host.port}"
    else
      port = ""
    end
    "#{Settings.host.protocol}#{Settings.host.name}#{port}#{spath}"
  end
end
