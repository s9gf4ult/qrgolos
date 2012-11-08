class VotesController < ApplicationController
  before_filter :get_anonymous
  
  def radio_vote
    begin
      if params[:answer_variant][:id] == nil
        raise "id not found"
      end
    rescue 
      respond_to do |format|
        format.html do
          flash[:notice] = t 'votes.choose_variant'
          redirect_to s_anonymous_path(@anonymous)
        end
        format.json { head :no_content, :status => :bad_request }
      end
      return
    end
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

  private
  def get_anonymous
    @anonymous = Anonymous.where(:fake => false, :aid => params[:_id]).first
    #  FIXME: make anonymous remember last time user entered
    if @anonymous == nil
      flash[:error] = t :wrong_aid
      redirect_to s_path
    end
  end

end
