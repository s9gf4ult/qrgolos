class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :set_initial_breadcrumbs



  private
  def set_initial_breadcrumbs
    add_breadcrumb (t :home), "/"
  end

  protected
  def section_breadcrumb(section)
    meeting_breadcrumb section.meeting
    add_breadcrumb section.name, section
  end

  def meetings_breadcrumb
    add_breadcrumb (t 'meetings.meetings'), meetings_path
  end

  def meeting_breadcrumb(meeting)
    meetings_breadcrumb
    add_breadcrumb meeting.name, meeting
  end

  def question_breadcrumb(question)
    section_breadcrumb question.section
    add_breadcrumb question.question, question
  end

  def answer_variant_breadcrumb(answer_variant)
    question_breadcrumb answer_variant.question
    add_breadcrumb answer_variant.text, answer_variant
  end

  def meeting_owner?(meeting)
    user_signed_in? and meeting.user == current_user
  end

  def section_owner?(section)
    meeting_owner?(section.meeting) #  FIXME: Here must be check of section
  end

  def s_anonymous_path(anonymous)
    aid = if anonymous.is_a?(Anonymous); then anonymous.aid else anonymous end
    "/s/#{aid}"
  end

  def get_and_check_anonymous   #  FIXME: moved to helper, fix in controllers
    @anonymous = Anonymous.find(params[:anonymous][:id])
    #  FIXME: make anonymous remember last time user entered
    if @anonymous.id != session[:anonymous_id]
      flash[:error] = t :wrong_aid
      redirect_to s_path
    end
  end
end
