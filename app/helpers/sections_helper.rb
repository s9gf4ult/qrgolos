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
