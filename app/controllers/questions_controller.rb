class QuestionsController < ApplicationController
  include ApplicationHelper
  before_filter :authenticate_user!, :except => [:show]
  before_filter :get_question, :except => [:new, :create]
  before_filter :stop_countdown_question, :except => [:new, :create]

  # GET /questions/1
  # GET /questions/1.json
  def show
    respond_to do |format|
      format.html do
        question_breadcrumb @question
        render
      end
      format.json do
        render :json => @question.as_json(:methods => [:countdown_remaining])
      end
    end
  end

  # GET /questions/new
  # GET /questions/new.json
  def new
    @section = Section.find(params[:section_id])
    when_section_owner @section, @section do
      @question = @section.questions.build
      respond_to do |format|
        format.html do
          question_breadcrumb @question
          render
        end
        format.json { render json: @question }
      end
    end
  end

  # GET /questions/1/edit
  def edit
    when_section_owner @question.section, @question.section do
      question_breadcrumb @question
    end
  end

  # POST /questions
  # POST /questions.json
  def create
    section = Section.find(params[:section][:id])
    when_section_owner section, section do
      @question = section.questions.build(params[:question].except(:state, :id, :section_id, :created_at, :updated_at))

      respond_to do |format|
        if @question.save
          format.html { redirect_to @question, notice: 'Question was successfully created.' }
          format.json { render json: @question, status: :created, location: @question }
        else
          format.html { render action: "new" }
          format.json { render json: @question.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PUT /questions/1
  # PUT /questions/1.json
  def update
    section = @question.section
    when_section_owner section, section do
      respond_to do |format|
        if @question.update_attributes(params[:question].except(:state, :countdown_to, :id, :section_id, :created_at, :updated_at))
          format.html { redirect_to section, notice: 'Question was successfully updated.' }
          format.json { head :no_content }
          if ["active", "showed", "statistics"].include? @question.state
            comet_section_question_changed section
          end
        else
          format.html { render action: "edit" }
          format.json { render json: @question.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /questions/1
  # DELETE /questions/1.json
  def destroy
    section = Section.find(@question.section)
    update = ["active", "showed"].include? @question.state
    when_section_owner section, section do
      @question.destroy

      respond_to do |format|
        format.html { redirect_to section }
        format.json { head :no_content }
        comet_section_question_changed section if update
      end
    end
  end

  def switch_state
    when_section_owner @question.section do
      @question.switch_state
      respond_to do |format|
        format.html { redirect_to @question.section }
        format.json { head :no_content }
        if @question.state != "new"
          comet_section_question_changed @question.section
        end
      end
    end
  end

  def reset_state
    when_section_owner @question.section do
      update = ["showed", "active", "statistics"].include? @question.state
      @question.reset_state
      respond_to do |format|
        format.html { redirect_to @question.section }
        format.json { head :no_content }
        comet_section_question_changed @question.section if update
      end
    end
  end

  def start_countdown
    when_section_owner @question.section do
      @question.start_countdown Settings.questions.countdown_time #  FIXME: make it configurable
      respond_to do |format|
        format.html { redirect_to @question.section }
        format.json { head :no_content }
        comet_section_question_changed @question.section
      end
    end
  end

  private
  def get_question
    @question = Question.find(params[:id])
  end

  def stop_countdown_question
    @question.stop_countdown
  end
end
