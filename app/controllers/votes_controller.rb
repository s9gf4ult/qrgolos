class VotesController < ApplicationController

  def radio_vote
    params[:id] = params[:_id]
    begin
      answer_variant = AnswerVariant.find params[:answer_variant][:id]
    rescue 
      flash[:notice] = t 'votes.choose_variant'
      redirect_to 
    end
    anonymous = Anonymous.find params[:_id]
    vote = anonymous.votes.build :answer_variant => answer_variant, :vote => 1
    respond_to do |format|
      if vote.save
        format.html do
          flash[:notice] = t 'votes.thanks'
          render :action => 's#show'
        end
        format.json { head :no_content, :status => :created }
      else
        format.html { render :action => 's#show' }
        format.json { render :json => vote.errors, :status => :unprocessable_entity }
      end
    end
  end
end
