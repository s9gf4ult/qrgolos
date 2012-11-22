class TwittsController < ApplicationController
  include ApplicationHelper
  before_filter :get_and_check_anonymous, :only => [:create]
  
  def create
    @twitt = @anonymous.twitts.build(params[:twitt].except(:state))
    respond_to do |format|
      if @twitt.save
        format.html { head :no_content }
        format.json { head :no_content, :status => :created }
        propogate_new_twitt(@anonymous.section)
      else
        format.html { redirect_to twitt_path(@anonymous.aid) }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    #  FIXME: fill this later
  end
end
