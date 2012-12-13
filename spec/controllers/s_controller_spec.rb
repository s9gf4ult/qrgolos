require 'spec_helper'

describe SController do
  describe "GET show" do
    before :each do
      @a = FactoryGirl.create :anonymous
    end
    
    it "should assign @anonymous" do
      get :show, {:id => @a.aid}
      assigns(:anonymous).should == @a
    end

    it "should assign @active" do
      get :show, {:id => @a.aid}
      assigns(:active).should == nil
    end

    it "should assign @active when active question" do
      s = @a.section
      q = FactoryGirl.create :question, :section => s
      FactoryGirl.create :answer_variant, :question => q
      s.active_question = q
      get :show, {:id => @a.aid}
      assigns(:active).should == q
    end

    it "should render template" do
      get :show, {:id => @a.aid}
      expect(response).to render_template("show")
    end
  end

  describe "GET twitt" do
    before :each do
      @a = FactoryGirl.create :anonymous, :name_number => nil
    end
    
    it "should assign @anonymous" do
      get :twitt, {:id => @a.aid}
      assigns(:anonymous).should == @a
    end

    it "should redirect to set_name" do
      get :twitt, {:id => @a.aid}
      expect(response).to redirect_to(name_path(@a.aid))
    end

    describe "with set name" do
      before :each do
        post :set_name, {:id => @a.aid, :anonymous => {:name => "name"}}
      end
    
      it "should render template after set name" do
        get :twitt, {:id => @a.aid}
        expect(response).to render_template("twitt")
      end

      it "should assign @twitt new object" do
        get :twitt, {:id => @a.aid}
        assigns(:twitt).should be_a_new(Twitt)
      end
    end
  end

  describe "GET name" do
    before :each do
      @a = FactoryGirl.create :anonymous, :name_number => nil
    end
    
    it "should render template when name is not set" do
      get :name, {:id => @a.aid}
      expect(response).to render_template("name")
    end

    it "should redirect to twitt when name is set" do
      post :set_name, {:id => @a.aid, :anonymous => {:name => "name"}}
      get :name, {:id => @a.aid}
      expect(response).to redirect_to(twitt_path(@a.aid))
    end
  end

  describe "POST set_name" do
    before :each do
      @a = FactoryGirl.create :anonymous, :name_number => nil
      @name = Faker::Name.first_name
    end

    it "should redirect to twitt" do
      post :set_name, {:id => @a.aid, :anonymous => {:name => @name}}
      expect(response).to redirect_to(twitt_path(@a.aid))
    end

    it "should update name_number and name" do
      post :set_name, {:id => @a.aid, :anonymous => {:name => @name}}
      @a.reload
      @a.name_number.should_not == nil
      @a.name.should == @name
    end
    
    # it "should not accept set name twice" do
    #   post :set_name, {:id => @a.aid, :anonymous => {:name => @name}}
    #   post :set_name, {:id => @a.aid, :anonymous => {:name => Faker::Name.first_name}}
    #   expect(response).to respond_to(
  end
end
