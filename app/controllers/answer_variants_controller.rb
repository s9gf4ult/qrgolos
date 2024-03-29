class AnswerVariantsController < ApplicationController
  before_filter :authenticate_user!, :except => [:show]
  # GET /answer_variants/1
  # GET /answer_variants/1.json
  def show
    @answer_variant = AnswerVariant.find(params[:id])
    answer_variant_breadcrumb @answer_variant
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @answer_variant }
    end
  end

  # GET /answer_variants/new
  # GET /answer_variants/new.json
  def new
    question = Question.find(params[:question_id])
    when_section_owner question.section, question do
      @answer_variant = question.answer_variants.build
      answer_variant_breadcrumb @answer_variant
      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @answer_variant }
      end
    end
  end

  # GET /answer_variants/1/edit
  def edit
    @answer_variant = AnswerVariant.find(params[:id])
    when_section_owner @answer_variant.question.section, @answer_variant.question do
      answer_variant_breadcrumb @answer_variant
    end
  end

  # POST /answer_variants
  # POST /answer_variants.json
  def create
    question = Question.find(params[:question][:id])
    when_section_owner question.section, question do
      @answer_variant = question.answer_variants.build(params[:answer_variant].except(:position, :id, :question_id, :created_at, :updated_at))
      @answer_variant.position = @answer_variant.last_position

      respond_to do |format|
        if @answer_variant.save
          format.html { redirect_to @answer_variant.question, notice: 'Answer variant was successfully created.' }
          format.json { render json: @answer_variant, status: :created, location: @answer_variant }
          propogate_aw @answer_variant
        else
          format.html { render action: "new" }
          format.json { render json: @answer_variant.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PUT /answer_variants/1
  # PUT /answer_variants/1.json
  def update
    @answer_variant = AnswerVariant.find(params[:id])
    when_section_owner @answer_variant.question.section, @answer_variant.question do
      respond_to do |format|
        if @answer_variant.update_attributes(params[:answer_variant].except(:position, :id, :question_id, :created_at, :updated_at))
          format.html { redirect_to @answer_variant.question, notice: 'Answer variant was successfully updated.' }
          format.json { head :no_content }
          propogate_aw @answer_variant
        else
          format.html { render action: "edit" }
          format.json { render json: @answer_variant.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /answer_variants/1
  # DELETE /answer_variants/1.json
  def destroy
    @answer_variant = AnswerVariant.find(params[:id])
    when_section_owner @answer_variant.question.section, @answer_variant.question do
      question = Question.find(@answer_variant.question)
      update = question.state == "active"
      @answer_variant.destroy

      respond_to do |format|
        format.html { redirect_to question }
        format.json { head :no_content }
        if update
          comet_section_question_changed question.section
        end
      end
    end
  end

  def bringup
    @answer_variant = AnswerVariant.find(params[:id])
    when_section_owner @answer_variant.question.section do
      respond_to do |format|
        if @answer_variant.bringup
          format.html { redirect_to @answer_variant.question, :notice => (t :bringed_up) }
          format.json { head :no_content }
          propogate_aw @answer_variant
        else
          format.html { redirect_to @answer_variant.question, :error => "Error" }
          format.json { render :json => "can not bring up", :status => :unprocessable_entity }
        end
      end
    end
  end

  def bringdown
    @answer_variant = AnswerVariant.find(params[:id])
    when_section_owner @answer_variant.question.section do
      respond_to do |format|
        if @answer_variant.bringdown
          format.html { redirect_to @answer_variant.question, :notice => (t :bringed_down) }
          format.json { head :no_content }
          propogate_aw @answer_variant
        else
          format.html { redirect_to @answer_variant.question, :error => "Error" }
          format.json { render :json => "can not bring up", :status => :unprocessable_entity }
        end
      end
    end
  end

  private

  def propogate_aw(answer_variant)
    if ["active", "showed", "statistics"].include? @answer_variant.question.state
      comet_section_question_changed @answer_variant.question.section
    end
  end
end
