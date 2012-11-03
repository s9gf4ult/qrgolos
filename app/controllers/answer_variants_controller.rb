class AnswerVariantsController < ApplicationController
  # GET /answer_variants
  # GET /answer_variants.json
  def index
    @answer_variants = AnswerVariant.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @answer_variants }
    end
  end

  # GET /answer_variants/1
  # GET /answer_variants/1.json
  def show
    @answer_variant = AnswerVariant.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @answer_variant }
    end
  end

  # GET /answer_variants/new
  # GET /answer_variants/new.json
  def new
    @answer_variant = AnswerVariant.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @answer_variant }
    end
  end

  # GET /answer_variants/1/edit
  def edit
    @answer_variant = AnswerVariant.find(params[:id])
  end

  # POST /answer_variants
  # POST /answer_variants.json
  def create
    @answer_variant = AnswerVariant.new(params[:answer_variant])

    respond_to do |format|
      if @answer_variant.save
        format.html { redirect_to @answer_variant, notice: 'Answer variant was successfully created.' }
        format.json { render json: @answer_variant, status: :created, location: @answer_variant }
      else
        format.html { render action: "new" }
        format.json { render json: @answer_variant.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /answer_variants/1
  # PUT /answer_variants/1.json
  def update
    @answer_variant = AnswerVariant.find(params[:id])

    respond_to do |format|
      if @answer_variant.update_attributes(params[:answer_variant])
        format.html { redirect_to @answer_variant, notice: 'Answer variant was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @answer_variant.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /answer_variants/1
  # DELETE /answer_variants/1.json
  def destroy
    @answer_variant = AnswerVariant.find(params[:id])
    @answer_variant.destroy

    respond_to do |format|
      format.html { redirect_to answer_variants_url }
      format.json { head :no_content }
    end
  end
end
