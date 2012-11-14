class QrcodeImages

  @queue = :qrcode_images

  def self.perform(section_id)
    s = Section.find(section_id)
    print s.name
  end
end
