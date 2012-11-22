require 'tmpdir'
require 'zip/zip'
class QrcodeImages
  include SHelper
  include ApplicationHelper
  attr_accessor :image_width, :image_height, :font_size, :addition

  @queue = :qrcode_images

  def initialize
    self.image_width = 800
    self.image_height = 600
    self.font_size = 25
    self.addition = 5
  end

  def self.perform(section_id)
    a = self.new
    begin
      bgn = Time.now
      a.perform section_id
      puts "######################## #{Time.now - bgn} secodns elapsed" #  FIXME: maybe replace with log ?
    rescue => detail
      puts detail
      detail.backtrace.each do |b|
        puts b
      end
    end
  end

  def with_tmp_directory
    begin
      tmpdir = File.expand_path "#{Rails.root}/tmp/#{SecureRandom.hex(10)}"
      FileUtils.mkdir_p tmpdir
      yield(tmpdir)
    ensure
      FileUtils.rm_rf tmpdir if File.exists? tmpdir
    end
  end

  def get_anonymous_qrcode(anonymous)
    (2..40).each do |size|
      begin
        qrcode = RQRCode::QRCode.new anonymous_full_path(anonymous), :size => size, :level => :h
        return qrcode
      rescue RQRCode::QRCodeRunTimeError

      end
    end
  end

  def anonymous_filename(anonymous)
    "#{anonymous.aid.to_s}.png"
  end

  def perform(section_id)
    section = Section.find(section_id)
    if section.anonymouss.count > 0
      with_tmp_directory do |dir|
        zipfile = "#{dir}/#{section_archive_name(section)}"
        Zip::ZipFile.open zipfile, Zip::ZipFile::CREATE do |zip|
          section.anonymouss.where(:fake => false, :active => true).each do |anonymous|
            img = Magick::Image.new self.image_width, self.image_height
            d = Magick::Draw.new
            d.stroke_antialias true
            d.text_antialias true
            d.font_style Magick::NormalStyle
            q = get_anonymous_qrcode(anonymous)
            d.qrcode_with_text q, section.name.to_s, anonymous_full_path(anonymous), self.font_size, self.addition, 0, 0, self.image_width, self.image_height
            d.draw img
            imgfile = File.expand_path "#{dir}/#{anonymous_filename(anonymous)}"
            img.write imgfile
            zip.add anonymous_filename(anonymous), imgfile
          end
        end
        archpath = "#{Rails.root}/public/files"
        FileUtils.mkdir_p archpath
        targetzip = "#{archpath}/#{section_archive_name(section)}"
        FileUtils.mv zipfile, targetzip
        FileUtils.chmod 0644, targetzip
      end
    end
  end
end
