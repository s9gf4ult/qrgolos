class SectionsController < ApplicationController
  before_filter :authenticate_user!, :except => [:show]
  before_filter :just_my_sections, :only => [:update, :destroy]
  
  # GET /sections/1
  # GET /sections/1.json
  def show
    @section = Section.find(params[:id])
    section_breadcrumb @section
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @section }
    end
  end

  # GET /sections/new
  # GET /sections/new.json
  def new
    @meeting = Meeting.find(params[:meeting_id])
    @section = @meeting.sections.build
    section_breadcrumb @section
    
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @section }
    end
  end

  # GET /sections/1/edit
  def edit
    @section = Section.find(params[:id])
    section_breadcrumb @section
  end

  # POST /sections
  # POST /sections.json
  def create
    meeting = Meeting.find(params[:meeting][:id])
    @section = meeting.sections.build(params[:section])

    respond_to do |format|
      if @section.save
        format.html { redirect_to @section, notice: 'Section was successfully created.' }
        format.json { render json: @section, status: :created, location: @section }
      else
        format.html { render action: "new" }
        format.json { render json: @section.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /sections/1
  # PUT /sections/1.json
  def update
    respond_to do |format|
      if @section.update_attributes(params[:section])
        format.html { redirect_to @section, notice: 'Section was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @section.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sections/1
  # DELETE /sections/1.json
  def destroy
    meeting = Meeting.find(@section.meeting)
    @section.destroy

    respond_to do |format|
      format.html { redirect_to meeting }
      format.json { head :no_content }
    end
  end

  private
  def just_my_sections
    @section = Section.find(params[:id])
    if not section_owner?(@section)
      flash[:error] = t "sections.no-access"
      redirect_to @section.meeting
    end
  end
end
