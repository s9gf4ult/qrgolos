class VotesController < ApplicationController

  def radio_vote
    answer_variant = AnswerVariant.find params[:answer_variant][:id]
    anonymous = Anonymous.find params[:id]
    vote = anonymous.votes.build {:answer_variant => answer_variant, :vote => 1}
    if vote.save
      respond_to do |format|
        format.html do
          flash[:notice] = t 'votes.thanks'
          redirect_to radio_path(anonymous.aid)
        end
        format.json {
        }                       #  FIXME: complete


  end
end
