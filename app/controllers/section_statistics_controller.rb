class SectionStatisticsController < ApplicationController
  def show
    @section = Section.find(params[:section_id])
    section_breadcrumb @section
    add_breadcrumb (t 'sections.statistics'), section_section_statistics_path(@section)
  end
end
