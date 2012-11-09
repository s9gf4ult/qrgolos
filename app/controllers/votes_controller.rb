class VotesController < ApplicationController
  before_filter :get_and_check_anonymous
  before_filter :check_answer_variant_id_string, :only => [:radio]
  before_filter :check_answer_variant_id_array, :only => [:check]
  
  def radio
    answer_variant = AnswerVariant.find(params[:answer_variant][:id])
    vote = @anonymous.votes.build :vote => 1
    vote.answer_variant = answer_variant
    respond_to do |format|
      if vote.save
        format.html do
          flash[:notice] = t 'votes.thanks'
          redirect_to s_anonymous_path(@anonymous)
        end
        format.json { head :no_content, :status => :created }
      else
        format.html { redirect_to s_anonymous_path(@anonymous) }
        format.json { render :json => vote.errors, :status => :unprocessable_entity }
      end
    end
  end

  def check
    answer_variants = params[:answer_variant][:id].map do |awid|
      AnswerVariant.find(awid)
    end
    votes = answer_variants.map do |aw|
      vote = @anonymous.votes.build :vote => 1
      vote.answer_variant = aw
      vote
    end

    respond_to do |format|
      if votes.all? {|v| v.save}
        format.html do
          flash[:notice] = t 'votes.thanks'
          redirect_to s_anonymous_path(@anonymous)
        end
        format.json { head :no_content, :status => :created }
      else
        format.html { redirect_to s_anonymous_path(@anonymous) }
        format.json { render :json => vote.errors, :status => :unprocessable_entity }
      end
    end
  end

  private

  def check_answer_variant_id_string
    check_params 'votes.choose_variant' do
      id = params[:answer_variant][:id]
      id.is_a? String
    end
  end

  def check_answer_variant_id_array
    check_params 'votes.choose_variant' do
      id = params[:answer_variant][:id]
      id.is_a? Array and id.length > 0
    end
  end

  def check_params(message)
    begin
      if not yield
        raise "is bad"
      end
    rescue 
      respond_to do |format|
        format.html do
          flash[:error] = t message
          redirect_to s_anonymous_path(@anonymous)
        end
        format.json { head :no_content, :status => :bad_request }
      end
    end
  end
end
