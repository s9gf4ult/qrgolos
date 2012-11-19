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
    
  end

  def show
    @active = @anonymous.section.active_question
  end

  def twitt
    if @anonymous.name_number == nil
      redirect_to name_path
      return
    end
    
    @twitt = @anonymous.twitts.build
    respond_to do |format|
      format.html { render }
      format.json { render :json => @anonymous.section.formated_twitts.take(20) }
    end
  end

  private
  def get_layout
    "anonymous"
  end

  def get_anonymous
    @anonymous = Anonymous.where(:fake => false, :aid => params[:id]).first
    #  FIXME: make anonymous remember last time user entered
    session[:anonymous_id] = @anonymous.id
    if @anonymous == nil
      flash[:error] = t :wrong_aid
      redirect_to s_path
    end
  end
end
