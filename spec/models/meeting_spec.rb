require 'spec_helper'

describe Meeting do
  it "should have unique name" do
    m = FactoryGirl.build :meeting, :name => "meeting name"
    m.save
    m2 = FactoryGirl.build :meeting, :name => "meeting name"
    m2.should_not be_valid
  end

  it "should require name" do
    m = FactoryGirl.build :meeting, :name => ""
    m.should_not be_valid
    m.name = "  "
    m.should_not be_valid
  end
end
