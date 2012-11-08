class VotesController < ApplicationController
  before_filter :get_anonymous
  before_filter :check_answer_variant_id_string, :only => [:radio_vote]
  before_filter :check_answer_variant_id_array, :only => [:check_vote]
  
  def radio_vote
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

  def check_vote
    logger.debug ">>>>>>>>>>>>>>>>>>>>>>> #{params[:answer_variant][:id]}"
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
  def get_anonymous
    @anonymous = Anonymous.where(:fake => false, :aid => params[:_id]).first
    #  FIXME: make anonymous remember last time user entered
    if @anonymous == nil
      flash[:error] = t :wrong_aid
      redirect_to s_path
    end
  end

  def check_answer_variant_id_string
    check_answer_variant_id do |id|
      id.is_a? String
    end
  end

  def check_answer_variant_id_array
    check_answer_variant_id do |id|
      id.is_a? Array and id.length > 0
    end
  end
  
  def check_answer_variant_id
    begin
      if not yield(params[:answer_variant][:id])
        raise "id is wrong"
      end
    rescue 
      respond_to do |format|
        format.html do
          flash[:notice] = t 'votes.choose_variant'
          redirect_to s_anonymous_path(@anonymous)
        end
        format.json { head :no_content, :status => :bad_request }
      end
    end
  end

end
