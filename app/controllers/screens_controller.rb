class ScreensController < ApplicationController
  layout :set_layout
  
  def show

  end

  def banner
    @section = Section.first
  end
  
  def twitts
    @section = Section.first
  end

  def question
    @section = Section.first
  end

  def statistics
    @section = Section.first
  end

  private

  def set_layout
    "screen"
  end
end
