class MeetingsController < ApplicationController
  before_filter :authenticate_user!, :except => [:index, :show]
  
  # GET /meetings
  # GET /meetings.json
  def index
    if user_signed_in?
      @my_meetings = current_user.meetings
      @meetings = current_user.find_foreign
    else 
      @meetings = Meeting.all
    end
    meetings_breadcrumb
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @meetings }
    end
  end

  # GET /meetings/1
  # GET /meetings/1.json
  def show
    @meeting = Meeting.find(params[:id])
    meeting_breadcrumb @meeting

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @meeting }
    end
  end

  # GET /meetings/new
  # GET /meetings/new.json
  def new
    @meeting = Meeting.new
    meeting_breadcrumb @meeting

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @meeting }
    end
  end

  # GET /meetings/1/edit
  def edit
    @meeting = Meeting.find(params[:id])
    when_meeting_owner @meeting do 
      meeting_breadcrumb @meeting
    end
  end

  # POST /meetings
  # POST /meetings.json
  def create
    @meeting = current_user.meetings.build(params[:meeting].except(:id, :user_id, :created_at, :updated_at))

    respond_to do |format|
      if @meeting.save
        format.html { redirect_to @meeting, notice: 'Meeting was successfully created.' }
        format.json { render json: @meeting, status: :created, location: @meeting }
      else
        format.html { render action: "new" }
        format.json { render json: @meeting.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /meetings/1
  # PUT /meetings/1.json
  def update
    @meeting = Meeting.find(params[:id])
    when_meeting_owner @meeting do 
      respond_to do |format|
        if @meeting.update_attributes(params[:meeting].except(:id, :user_id, :created_at, :updated_at))
          format.html { redirect_to @meeting, notice: 'Meeting was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: "edit" }
          format.json { render json: @meeting.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /meetings/1
  # DELETE /meetings/1.json
  def destroy
    @meeting = Meeting.find(params[:id])
    when_meeting_owner @meeting do 
      @meeting.destroy

      respond_to do |format|
        format.html { redirect_to meetings_url }
        format.json { head :no_content }
      end
    end
  end
end
