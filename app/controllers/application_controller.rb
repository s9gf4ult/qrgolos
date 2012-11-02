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

  def meeting_breadcrumb(meeting)
    add_breadcrumb meeting.name, meeting
  end

  def question_breadcrumb(question)
    section_breadcrumb question.section
    add_breadcrumb question.question, question
  end

  def meeting_owner?(meeting)
    user_signed_in? and meeting.user == current_user
  end

  def section_owner?(section)
    meeting_owner?(section.meeting) #  FIXME: Here must be check of section
  end

end
