require 'spec_helper'

describe Screen do
  it "should have devault state = 'banner'" do
    s = FactoryGirl.create :section
    screen = s.screens.build
    screen.state.should == 'banner'
  end

  describe "validations" do
    before :each do
      @s = FactoryGirl.build :screen
    end
    
    it "should require state" do
      @s.state = " "
      @s.should_not be_valid
    end
    
    it "should accept valid state" do
      ["banner", "twitts", "question"].each do |state|
        @s.state = state
        @s.should be_valid
      end
    end
    
    it "should reject invalid state" do
      @s.state = "invalid"
      @s.should_not be_valid
    end
  end
end
