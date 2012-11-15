class SectionsController < ApplicationController
  before_filter :authenticate_user!, :except => [:show, :twitts]

  def twitts_edit
    @section = Section.find(params[:id])
    when_section_owner @section do
      section_breadcrumb @section
      add_breadcrumb (t 'sections.twitts-edit'), twitts_edit_section_path(@section)
    end
  end

  def twitts
    @section = Section.find(params[:id])
    section_breadcrumb @section
    add_breadcrumb (t 'sections.twitts'), twitts_section_path(@section)
  end

  def activate_twitt
    twitt = Twitt.find(params[:twitt_id])
    when_section_owner twitt.anonymous.section do
      twitt.state = if twitt.state == "new"; then "active" else "new" end
      respond_to do |format|
        if twitt.save
          format.html {redirect_to twitts_edit_section_path(twitt.anonymous.section)}
          format.json {header :no_content}
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
    when_meeting_owner meeting do
      @section = meeting.sections.build(params[:section].except(:anonymous_count))
      
      respond_to do |format|
        if @section.save
          @section.anonymous_count = params[:section][:anonymous_count]
          format.html { redirect_to @section, notice: 'Section was successfully created.' }
          format.json { render json: @section, status: :created, location: @section }
          Resque.enqueue(QrcodeImages, @section.id) # And now we must regenerate pictures
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
        if @section.update_attributes(params[:section])
          format.html { redirect_to @section, notice: 'Section was successfully updated.' }
          format.json { head :no_content }
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
      end
    end
  end
end
