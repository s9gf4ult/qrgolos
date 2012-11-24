class ScreensController < ApplicationController
  layout :set_layout
  
  def show
    @screen = Screen.find(params[:id])
    with_right_content @screen
  end

  def banner
    @screen = Screen.find(params[:id])
    with_right_content @screen, "banner" do
      @section = @screen.section
    end
  end
  
  def twitts
    @screen = Screen.find(params[:id])
    with_right_content @screen, "twitts" do
      @section = @screen.section
      respond_to do |format|
        format.html { render }  # question.html.erb
        format.json do
          ret = Jbuilder.encode do |j|
            j.section @section
            j.twitts @section.active_twitts do |twitt|
              j.name twitt.anonymous.formated_name
              j.text twitt.text
              j.time twitt.created_at
            end
          end
          render :json => ret
        end
      end
    end
  end

  def question
    @screen = Screen.find(params[:id])
    if @screen.section.active_question
      @screen.section.active_question.stop_countdown
    end
    with_right_content @screen, "question" do
      @section = @screen.section
      respond_to do |format|
        format.html { render }  # question.html.erb
        format.json { render :json => render_json_question(@section.active_question) }
      end
    end
  end

  def statistics
    @screen = Screen.find(params[:id])
    if @screen.section.active_question
      @screen.section.active_question.stop_countdown
    end
    with_right_content @screen, "statistics" do
      @section = @screen.section
      respond_to do |format|
        format.html { render }  # statistics.html.erb
        format.json { render :json => render_json_question(@section.statistics_question) }
      end
    end
  end

  def update
    @screen = Screen.find(params[:id])
    when_section_owner @screen.section do
      respond_to do |format|
        if @screen.update_attributes(params[:screen])
          format.html { redirect_to @screen.section }
          format.json { head :no_content }
          comet_screen_update @screen
        else
          format.html { redirect_to @screen.section }
          format.json { render :json => @screen.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  private

  def render_json_question(question)
    Jbuilder.encode do |j|
      if question
        q = question
        j.question do
          j.question q.question
          j.countdown_remaining q.countdown_remaining
        end
        j.answer_variants q.formated_answer_variants
      else
        j.question nil
      end
    end
  end

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
        redirect_to statistics_screen_path(screen)
      end
    end
  end
end
