require 'spec_helper'

describe Twitt do
  it "should require text" do
    t = FactoryGirl.build :twitt, :text => ""
    t.should_not be_valid
  end

  it "state should accept just 'new' and 'active'" do
    t = FactoryGirl.build :twitt, :state => ""
    t.should_not be_valid
    t.state = "new"
    t.should be_valid
    t.state = "active"
    t.should be_valid
    t.state = "asdf"
    t.should_not be_valid
  end
end
