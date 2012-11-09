module SHelper
  def s_anonymous_path(anonymous)
    aid = if anonymous.is_a?(Anonymous); then anonymous.aid else anonymous end
    "/s/#{aid}"
  end
end
