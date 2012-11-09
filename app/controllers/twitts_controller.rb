class TwittsController < ApplicationController
  before_filter :get_and_check_anonymous, :only => [:create]
  
  def create
    @twitt = @anonymous.twitts.build(params[:twitt].except(:state))
    respond_to do |format|
      if @twitt.save
        format.html { redirect_to twitt_path(@anonymous.aid) }
        format.json { head :no_content, :status => :created }
      else
        format.html { redirect_to twitt_path(@anonymous.aid) }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end

  def activate
    #  FIXME: fill this later
  end

  def destroy
    #  FIXME: fill this later
  end
end
