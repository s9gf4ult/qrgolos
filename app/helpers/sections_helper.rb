module SectionsHelper
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
end
