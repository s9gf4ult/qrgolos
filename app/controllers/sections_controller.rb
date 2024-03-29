class SectionsController < ApplicationController
  include ApplicationHelper
  before_filter :authenticate_user!, :except => [:show, :twitts]

  def twitts_edit               #  FIXME: move to separate controller
    @section = Section.find(params[:id])
    when_section_owner @section, @section do
      section_breadcrumb @section
      add_breadcrumb (t 'sections.twitts-edit'), twitts_edit_section_path(@section)
    end
  end

  def twitts                    #  FIXME: move to separate controller
    @section = Section.find(params[:id])
    section_breadcrumb @section
    add_breadcrumb (t 'sections.twitts'), twitts_section_path(@section)
  end

  def activate_twitt            #  FIXME: move to separate controller
    twitt = Twitt.find(params[:twitt_id])
    when_section_owner twitt.anonymous.section do
      twitt.state = if twitt.state == "new"; then "active" else "new" end
      respond_to do |format|
        if twitt.save
          format.html {redirect_to twitts_edit_section_path(twitt.anonymous.section)}
          format.json {header :no_content}
          comet_section_twitts_activated twitt.anonymous.section
        else
          format.html {redirect_to twitts_edit_section_path(twitt.anonymous.section)}
          format.json {render :json => twitt.errors, :status => :unprocessable_entity}
        end
      end
    end
  end

  # GET /sections/1
  # GET /sections/1.json
  def show
    @section = Section.find(params[:id])
    section_breadcrumb @section
    if @section.active_question
      @section.active_question.stop_countdown
    end
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @section }
    end
  end

  # GET /sections/new
  # GET /sections/new.json
  def new
    @meeting = Meeting.find(params[:meeting_id])
    when_meeting_owner @meeting do
      @section = @meeting.sections.build
      section_breadcrumb @section

      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @section }
      end
    end
  end

  # GET /sections/1/edit
  def edit
    @section = Section.find(params[:id])
    when_section_owner @section do
      section_breadcrumb @section
    end
  end

  # POST /sections
  # POST /sections.json
  def create
    meeting = Meeting.find(params[:meeting][:id])
    when_meeting_owner meeting, meeting do
      @section = meeting.sections.build(params[:section].except(:anonymous_count, :screens_count, :id, :meeting_id, :created_at, :updated_at))
      respond_to do |format|
        if @section.save
          @section.anonymous_count = params[:section][:anonymous_count] || 0
          @section.screens_count = params[:section][:screens_count] || 0
          format.html { redirect_to @section, notice: 'Section was successfully created.' }
          format.json { render json: @section, status: :created, location: @section }
          enqueue_archive_generation(@section)
        else
          format.html { render action: "new" }
          format.json { render json: @section.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PUT /sections/1
  # PUT /sections/1.json
  def update
    @section = Section.find(params[:id])
    when_section_owner @section do
      respond_to do |format|
        if @section.update_attributes(params[:section].except(:id, :meeting_id, :created_at, :updated_at))
          format.html { redirect_to @section, notice: 'Section was successfully updated.' }
          format.json { head :no_content }
          remove_section_archive(@section)
          enqueue_archive_generation(@section)
        else
          format.html { render action: "edit" }
          format.json { render json: @section.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /sections/1
  # DELETE /sections/1.json
  def destroy
    @section = Section.find(params[:id])
    when_section_owner @section do
      meeting = Meeting.find(@section.meeting)
      @section.destroy

      respond_to do |format|
        format.html { redirect_to meeting }
        format.json { head :no_content }
        remove_section_archive(@section)
      end
    end
  end
end
