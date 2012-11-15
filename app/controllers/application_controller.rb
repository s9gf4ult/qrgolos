class ApplicationController < ActionController::Base
  include ApplicationHelper
  protect_from_forgery
  before_filter :set_initial_breadcrumbs

  def default_url_options
    if Rails.env.production?
      {}
    else  
      {}
    end
  end

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

  def when_meeting_owner(meeting)
    if meeting_owner? meeting
      yield
    else
      flash[:error] = t "meetings.no-access"
      redirect_to meetings_path
    end
  end

  def when_section_owner(section)
    if section_owner? section
      yield
    else
      flash[:error] = t "sections.no-access"
      redirect_to section.meeting
    end
  end

  def s_anonymous_path(anonymous)
    aid = if anonymous.is_a?(Anonymous); then anonymous.aid else anonymous end
    "/s/#{aid}"
  end

  def get_and_check_anonymous   #  FIXME: moved to helper, fix in controllers
    @anonymous = Anonymous.find(params[:anonymous][:id])
    #  FIXME: make anonymous remember last time user entered
    if @anonymous.id != session[:anonymous_id]
    end
  end
end
