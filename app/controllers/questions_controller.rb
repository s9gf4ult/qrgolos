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
    when_section_owner @section do
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
    when_section_owner @question.section do
      question_breadcrumb @question
    end
  end

  # POST /questions
  # POST /questions.json
  def create
    section = Section.find(params[:section][:id])
    when_section_owner section do
      @question = section.questions.build(params[:question].except(:state))

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
    when_section_owner @question.section do
      respond_to do |format|
        if @question.update_attributes(params[:question].except(:state, :countdown_to))
          format.html { redirect_to @question, notice: 'Question was successfully updated.' }
          format.json { head :no_content }
          if @question.state == "active"
            comet_section_question_changed @question.section
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
    update = false
    if @question.state == "active"
      update = true
    end
    when_section_owner section do
      @question.destroy

      respond_to do |format|
        format.html { redirect_to section }
        format.json { head :no_content }
        if update
          comet_section_question_changed section
        end
      end
    end
  end

  def switch_state
    update = @question.state != "finished"
    when_section_owner @question.section do
      @question.switch_state
      respond_to do |format|
        format.html { redirect_to @question.section }
        format.json { head :no_content }
        if update
          comet_section_question_changed @question.section
        end
      end
    end
  end

  def reset_state
    update = @question.state != "finished"
    when_section_owner @question.section do
      @question.reset_state
      respond_to do |format|
        format.html { redirect_to @question.section }
        format.json { head :no_content }
        if update
          comet_section_question_changed @question.section
        end
      end
    end
  end

  def start_countdown
    update = @question.state != "finished"
    when_section_owner @question.section do
      @question.start_countdown Settings.questions.countdown_time #  FIXME: make it configurable
      respond_to do |format|
        format.html { redirect_to @question.section }
        format.json { head :no_content }
        if update
          comet_section_question_changed @question.section
        end
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
