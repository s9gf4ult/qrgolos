require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe SectionsController do

  describe "GET show" do
    it "assigns the requested section as @section" do
      section = FactoryGirl.create :section
      get :show, {:id => section.to_param}
      assigns(:section).should eq(section)
    end
  end

  describe "GET new" do
    it "should redirect if not authenticated" do
      m = FactoryGirl.create :meeting
      get :new, {:meeting_id => m.id}
      expect(response).to redirect_to(new_user_session_path)
    end

    it "should reject if not meeting owner" do
      m = FactoryGirl.create :meeting
      u = FactoryGirl.create :user
      sign_in u
      get :new, {:meeting_id => m.id}
      expect(response).to redirect_to(meetings_path)
    end
    
    it "assigns a new section as @section" do
      m = FactoryGirl.create :meeting
      user = m.user
      sign_in user
      get :new, {:meeting_id => m.id}
      assigns(:section).should be_a_new(Section)
    end
  end

  describe "GET edit" do
    it "should reject if not authenticated" do
      s = FactoryGirl.create :section
      get :edit, {:id => s.to_param}
      expect(response).to redirect_to(new_user_session_path)
    end

    it "should reject if not meeting owner" do
      s = FactoryGirl.create :section
      sign_in FactoryGirl.create(:user)
      get :edit, {:id => s.to_param}
      expect(response).to redirect_to(s.meeting)
    end
    
    it "assigns the requested section as @section" do
      section = FactoryGirl.create :section
      u = section.meeting.user
      sign_in u
      get :edit, {:id => section.to_param}
      assigns(:section).should eq(section)
      expect(response).to render_template("edit")
    end
  end

  describe "POST create" do
    it "should redirect if not athenticated" do
      s = FactoryGirl.build :section
      post :create, {:section => s.attributes, :meeting => {:id => s.meeting.id}}
      expect(response).to redirect_to(new_user_session_path)
    end

    it "should reject if not meeting owner" do
      s = FactoryGirl.build :section
      sign_in FactoryGirl.create(:user)
      post :create, {:section => s.attributes, :meeting => {:id => s.meeting.id}}
      expect(response).to redirect_to(s.meeting)
    end
    
    describe "with valid params" do
      it "creates a new Section" do
        s = FactoryGirl.build :section
        sign_in s.meeting.user
        expect {
          post :create, {:section => s.attributes, :meeting => {:id => s.meeting.id}}
        }.to change(Section, :count).by(1)
      end

      it "assigns a newly created section as @section" do
        s = FactoryGirl.build :section
        sign_in s.meeting.user
        post :create, {:section => s.attributes, :meeting => {:id => s.meeting.id}}
        assigns(:section).should be_a(Section)
        assigns(:section).should be_persisted
      end

      it "redirects to the created section" do
        s = FactoryGirl.build :section
        sign_in s.meeting.user
        post :create, {:section => s.attributes, :meeting => {:id => s.meeting.id}}
        response.should redirect_to(Section.last)
      end
    end
  end

  describe "PUT update" do
    describe "with invalid auth" do
      before :each do
        @s = FactoryGirl.create :section
        @ss = FactoryGirl.build :section
      end
      
      it "should redirect when not authenticated" do
        put :update, {:id => @s.to_param, :section => @ss.attributes}
        expect(response).to redirect_to(new_user_session_path)
      end

      it "should redirect when not section owner" do
        sign_in FactoryGirl.create(:user)
        put :update, {:id => @s.to_param, :section => @ss.attributes}
        expect(response).to redirect_to(@s.meeting)
      end
    end
    
    describe "with valid params" do
      before :each do
        @s = FactoryGirl.create :section
        @ss = FactoryGirl.build :section
        sign_in @s.meeting.user
      end
      
      it "assigns the requested section as @section" do
        put :update, {:id => @s.to_param, :section => @ss.attributes}
        assigns(:section).should eq(@s)
      end

      it "redirects to the section" do
        put :update, {:id => @s.to_param, :section => @ss.attributes}
        response.should redirect_to(@s)
      end
    end
  end

  describe "DELETE destroy" do
    describe "without authentication" do
      before :each do
        @s = FactoryGirl.create :section
      end

      it "should reject if not authenticated" do
        delete :destroy, {:id => @s.to_param}
        expect(response).to redirect_to(new_user_session_path)
      end

      it "should reject if not section owner" do
        sign_in FactoryGirl.create(:user)
        delete :destroy, {:id => @s.to_param}
        expect(response).to redirect_to(@s.meeting)
      end
    end
    describe "with authentication" do
      before :each do
        @section = FactoryGirl.create :section
        sign_in @section.meeting.user
      end

      it "destroys the requested section" do
        expect {
          delete :destroy, {:id => @section.to_param}
        }.to change(Section, :count).by(-1)
      end

      it "redirects to the sections list" do
        delete :destroy, {:id => @section.to_param}
        response.should redirect_to(@section.meeting)
      end
    end
  end

  describe "GET twitts_edit" do
    describe "without authentication" do
      before :each do
        @s = FactoryGirl.create :section
      end

      it "should redirect if not authenticated" do
        get :twitts_edit, {:id => @s.to_param}
        expect(response).to redirect_to(new_user_session_path)
      end

      it "should reject if not section owner" do
        sign_in FactoryGirl.create(:user)
        get :twitts_edit, {:id => @s.to_param}
        expect(response).to redirect_to(@s)
      end
    end
  end

  describe "with authentication" do
    before :each do
      @s = FactoryGirl.create :section
      sign_in @s.meeting.user
    end

    it "should render template" do
      get :twitts_edit, {:id => @s.to_param}
      expect(response).to render_template("twitts_edit")
    end
  end

  describe "GET twitts_edit" do
    describe "without authentication" do
      before :each do
        @s = FactoryGirl.create :section
      end

      it "should redirect if not authenticated" do
        get :twitts_edit, {:id => @s.to_param}
        expect(response).to redirect_to(new_user_session_path)
      end

      it "should reject if not section owner" do
        sign_in FactoryGirl.create(:user)
        get :twitts_edit, {:id => @s.to_param}
        expect(response).to redirect_to(@s)
      end
    end
    
    describe "with authentication" do
      before :each do
        @s = FactoryGirl.create :section
        sign_in @s.meeting.user
      end

      it "should render template" do
        get :twitts_edit, {:id => @s.to_param}
        expect(response).to render_template("twitts_edit")
      end
    end
  end

  describe "GET twitts" do
    before :each do
      @s = FactoryGirl.create :section
    end

    it "should render template" do
      get :twitts, {:id => @s.to_param}
      expect(response).to render_template("twitts")
    end
  end
end
