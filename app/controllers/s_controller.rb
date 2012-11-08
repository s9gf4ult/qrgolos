class SController < ApplicationController
  before_filter :get_anonymous, :except => [:index]
  layout :get_layout


  def index
    
  end

  def show
    @active = @anonymous.section.active_question
  end

  private
  def get_anonymous
    @anonymous = Anonymous.where(:fake => false, :aid => params[:id]).first
    #  FIXME: make anonymous remember last time user entered
    if @anonymous == nil
      flash[:error] = t :wrong_aid
      redirect_to s_path
    end
  end

  def get_layout
    "anonymous"
  end
end
