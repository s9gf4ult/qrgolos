class SController < ApplicationController
  before_filter :get_anonymous, :except => [:index]
  layout :get_layout


  def index

  end

  def set_name
    @anonymous.name = params[:anonymous][:name]
    @anonymous.name_number = @anonymous.find_name_number
    respond_to do |format|
      if @anonymous.save
        format.html { redirect_to twitt_path(@anonymous.aid) }
        format.json { render :json => @anonymous }
      else
        format.html do
          flash[:error] = @anonymous.errors
          redirect_to s_anonymous_path(@anonymous)
        end
        format.json { render :json => {:erros => @anonymous.errors} }
      end
    end
  end

  def name
    if @anonymous.name_number
      redirect_to twitt_path(@anonymous.aid)
    else
      render
    end
  end

  def show
    @active = @anonymous.section.active_question
    if @active
      @active.stop_countdown
    end
    @twitt = @anonymous.twitts.build
  end

  def twitt
    if @anonymous.name_number == nil
      redirect_to name_path(@anonymous.aid)
    else
      @twitt = @anonymous.twitts.build
      respond_to do |format|
        format.html { render }
        format.json { render :json => @anonymous.section.formated_active_twitts.take(20) }
      end
    end
  end

  private
  def get_layout
    "mobile"
  end

  def get_anonymous
    @anonymous = Anonymous.where(:fake => false, :aid => params[:id]).first
    #  FIXME: make anonymous remember last time user entered
    if @anonymous == nil
      flash[:error] = t :wrong_aid
      redirect_to s_path
    else
      session[:anonymous_id] = @anonymous.id
    end
  end
end
