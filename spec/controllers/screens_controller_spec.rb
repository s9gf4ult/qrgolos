require 'spec_helper'

describe ScreensController do
  describe "PUT update" do
    describe "without authorization" do
      before :each do
        @s = FactoryGirl.create :screen
        @s2 = FactoryGirl.build :screen
      end
      
      it "should require authorization" do
        put :update, {:id => @s.to_param, :screen => @s2.attributes}
        expect(response).to redirect_to(new_user_session_path)
      end

      it "should require user is section's owner" do
        sign_in FactoryGirl.create(:user)
        put :update, {:id => @s.to_param, :screen => @s2.attributes}
        expect(response).to redirect_to(@s.section)
      end
    end

    describe "with authorization" do
      before :each do
        @s = FactoryGirl.create :screen
        @user = @s.section.meeting.user
        sign_in @user
        @s2 = FactoryGirl.build :screen
      end

      describe "with valid parameters" do
        it "should assign @screen" do
          put :update, {:id => @s.to_param, :screen => @s2.attributes}
          assigns(:screen).should == @s
        end

        it "should redirect to section" do
          put :update, {:id => @s.to_param, :screen => @s2.attributes}
          expect(response).to redirect_to(@s.section)
        end
        
        it "should update state" do
          state = if @s.state == "question"; then "banner" else "question" end
          put :update, {:id => @s.to_param, :screen => {:state => state}}
          @s.reload
          @s.state.should == state
        end
      end

      describe "with invalid parameters" do
        it "should redirect to section" do
          put :update, {:id => @s.to_param, :screen => {}}
          expect(response).to redirect_to(@s.section)
        end
      end
    end
  end
  
  describe "GET show" do
    before :each do
      @s = FactoryGirl.create :screen
    end

    it "should assign @screen" do
      get :show, {:id => @s.to_param}
      assigns(:screen).should == @s
    end

    it "should redirect to question action" do
      @s.update_attributes :state => "question"
      get :show, {:id => @s.to_param}
      expect(response).to redirect_to(question_screen_path(@s))
    end

    it "should redirect to banner action" do
      @s.update_attributes :state => "banner"
      get :show, {:id => @s.to_param}
      expect(response).to redirect_to(banner_screen_path(@s))
    end

    it "should redirect to twitts action" do
      @s.update_attributes :state => "twitts"
      get :show, {:id => @s.to_param}
      expect(response).to redirect_to(twitts_screen_path(@s))
    end
  end

  describe "GET banner" do
    before :each do
      @s = FactoryGirl.create :screen
    end

    it "should assign @screen" do
      get :banner, {:id => @s.to_param}
      assigns(:screen).should == @s
    end

    it "should render when state is 'banner'" do
      @s.update_attributes :state => "banner"
      get :banner, {:id => @s.to_param}
      expect(response).to render_template("banner")
    end

    it "should redirect to question action" do
      @s.update_attributes :state => "question"
      get :banner, {:id => @s.to_param}
      expect(response).to redirect_to(question_screen_path(@s))
    end

    it "should redirect to twitts action" do
      @s.update_attributes :state => "twitts"
      get :banner, {:id => @s.to_param}
      expect(response).to redirect_to(twitts_screen_path(@s))
    end
  end

  describe "GET twitts" do
    before :each do
      @s = FactoryGirl.create :screen
    end

    it "should assign @screen" do
      get :twitts, {:id => @s.to_param}
      assigns(:screen).should == @s
    end

    it "should render when state is 'twitts'" do
      @s.update_attributes :state => "twitts"
      get :twitts, {:id => @s.to_param}
      expect(response).to render_template("twitts")
    end

    it "should redirect to banner action" do
      @s.update_attributes :state => "banner"
      get :twitts, {:id => @s.to_param}
      expect(response).to redirect_to(banner_screen_path(@s))
    end

    it "should redirect to question action" do
      @s.update_attributes :state => "question"
      get :twitts, {:id => @s.to_param}
      expect(response).to redirect_to(question_screen_path(@s))
    end
  end

  describe "GET question" do
    before :each do
      @s = FactoryGirl.create :screen
    end

    it "should assign @screen" do
      get :question, {:id => @s.to_param}
      assigns(:screen).should == @s
    end

    it "should render when state is 'question'" do
      @s.update_attributes :state => "question"
      get :question, {:id => @s.to_param}
      expect(response).to render_template("question")
    end

    it "should redirect to banner action" do
      @s.update_attributes :state => "banner"
      get :question, {:id => @s.to_param}
      expect(response).to redirect_to(banner_screen_path(@s))
    end

    it "should redirect to twitts action" do
      @s.update_attributes :state => "twitts"
      get :question, {:id => @s.to_param}
      expect(response).to redirect_to(twitts_screen_path(@s))
    end
  end
end
