require 'spec_helper'

describe SectionStatisticsController do
  describe "GET show" do
    before :each do
      @s = FactoryGirl.create :section
    end

    it "should render template" do
      get :show, {:section_id => @s.id}
      expect(response).to render_template("show")
    end

    it "should assign @section" do
      get :show, {:section_id => @s.id}
      assigns(:section).should == @s
    end
  end
end
