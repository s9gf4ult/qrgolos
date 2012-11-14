# -*- coding: utf-8 -*-
require 'rubygems'
require 'RMagick'
require 'rqrcode'

module Magick
  class Draw
    def qrcode(qrcode, left_corner, top_corner, right_corner, bottom_corner)
      size = qrcode.modules.length
      width = right_corner - left_corner
      height = bottom_corner - top_corner
      wset = width.to_f / size
      hset = height.to_f / size
      qrcode.modules.each_index do |x|
        qrcode.modules.each_index do |y|
          if qrcode.dark? y, x
            lc = left_corner + (x * wset)
            tc = top_corner + (y * hset)
            self.rectangle lc, tc, lc + wset, tc + hset
          end
        end
      end
    end

    def qrcode_with_text(qrcode, top_text, bottom_text, font_size, addition, left_corner, top_corner, right_corner, bottom_corner)
      self.text_align Magick::CenterAlign
      self.gravity Magick::NorthGravity
      self.font_size font_size
      width = right_corner - left_corner
      height = bottom_corner - top_corner
      center_x = width.to_f / 2 + left_corner
      self.text center_x, top_corner + font_size, top_text
      qrsize = height - (2 * font_size) - (2 * addition)
      qr_top = top_corner + font_size + addition
      qr_left = center_x - (qrsize.to_f / 2)
      qr_right = center_x + (qrsize.to_f / 2)
      qr_bottom = qr_top + qrsize
      self.qrcode qrcode, qr_left, qr_top, qr_right, qr_bottom
      self.text center_x, qr_bottom + font_size, bottom_text
    end
  end
end
