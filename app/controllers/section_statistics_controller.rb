class SectionStatisticsController < ApplicationController
  def show
    @section = Section.find(params[:section_id])
  end
end
