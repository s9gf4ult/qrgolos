class ScreensController < ApplicationController
  layout :set_layout
  
  def show
    @screen = Screen.find(params[:id])
    with_right_content @screen
  end

  def banner
    @screen = Screen.find(params[:id])
    # with_right_content @screen, "banner" do
      @section = @screen.section
    # end
  end
  
  def twitts
    @screen = Screen.find(params[:id])
    # with_right_content @screen, "twitts" do
      @section = @screen.section
    # end
  end

  def question
    @screen = Screen.find(params[:id])
    # with_right_content @screen, "question" do
      @section = @screen.section
    # end
  end

  def statistics
    @screen = Screen.find(params[:id])
    # with_right_content @screen, "statistics" do
      @section = @screen.section
    # end
  end

  private

  def set_layout
    "screen"
  end

  def with_right_content(screen, content=nil)
    if screen.state == content
      yield if block_given?
    else
      case screen.state
      when "banner"
        redirect_to banner_screen_path(screen)
      when "twitts"
        redirect_to twitts_screen_path(screen)
      when "question"
        redirect_to question_screen_path(screen)
      when "statistics"
        redirect_to statistics_screen(screen)
      end
    end
  end
end
