class QuestionsController < ApplicationController
  include ApplicationHelper
  before_filter :authenticate_user!, :except => [:show]
  
  # GET /questions/1
  # GET /questions/1.json
  def show
    @question = Question.find(params[:id])
    question_breadcrumb @question
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @question }
    end
  end

  # GET /questions/new
  # GET /questions/new.json
  def new
    @section = Section.find(params[:section_id])
    when_section_owner @section do
      @question = @section.questions.build
      question_breadcrumb @question
      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @question }
      end
    end
  end

  # GET /questions/1/edit
  def edit
    @question = Question.find(params[:id])
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
    @question = Question.find(params[:id])
    when_section_owner @question.section do
      respond_to do |format|
        if @question.update_attributes(params[:question].except(:state))
          format.html { redirect_to @question, notice: 'Question was successfully updated.' }
          format.json { head :no_content }
          if @question.state == "active"
            comet_session_question_changed(@question.section)
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
    @question = Question.find(params[:id])
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
          comet_session_question_changed(session)
        end
      end
    end
  end

  def activate
    @question = Question.find(params[:id])
    when_section_owner @question.section do
      @question.section.active_question = @question
      respond_to do |format|
        format.html { redirect_to @question.section, notice: (t "questions.activated") }
        format.json { head :no_content }
        comet_session_question_changed(@question.section)
      end
    end
  end

  def cancel
    @question = Question.find(params[:id])
    update = false
    if @question.state == "active"
      update = true
    end
    when_section_owner @question.section do
      @question.state = "canceled"
      respond_to do |format|
        if @question.save
          format.html { redirect_to @question.section, notice: (t "questions.canceled") }
          format.json { head :no_content }
          comet_session_question_changed(@question.session)
        else
          format.html { render action: "edit" }
          format.json { render json: @question.errors, status: :unprocessable_entity }
        end
      end
    end
  end
end
