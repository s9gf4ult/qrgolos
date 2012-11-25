class SectionStatisticsController < ApplicationController
  def show
    @section = Section.find(params[:section_id])
    section_breadcrumb @section
    if @section.active_question
      @section.active_question.stop_countdown
    end
    add_breadcrumb (t 'sections.statistics'), section_section_statistics_path(@section)
  end
end
