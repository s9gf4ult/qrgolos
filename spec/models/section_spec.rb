require 'spec_helper'

describe Section do
  it "should have unique name inside meeting" do
    m = FactoryGirl.create :meeting
    s = FactoryGirl.create :section, :name => "name", :meeting => m
    s2 = FactoryGirl.build :section, :name => "name", :meeting => m
    s2.should_not be_valid
  end

  it "should accept same name in different meetings" do
    s = FactoryGirl.create :section, :name => "name"
    s2 = FactoryGirl.build :section, :name => "name" # meering is different
    s2.should be_valid
  end

  it "should require name" do
    s = FactoryGirl.build :section, :name => ""
    s.should_not be_valid
    s.name = "  "
    s.should_not be_valid
  end

  it "should change anonymous count" do
    s = FactoryGirl.create :section
    lambda do
      s.anonymous_count = 10
    end.should change(s, :anonymous_count).from(0).to(10)

    lambda do
      s.anonymous_count = 50
    end.should change(s, :anonymous_count).to(50)

    lambda do
      s.anonymous_count = 20
    end.should change(s, :anonymous_count).to(20)

    s.anonymouss.count.should == 50 # maximum generated anonymous count
  end

  it "should change screens count" do
    s = FactoryGirl.create :section
    lambda do
      s.screens_count = 4
    end.should change(s, :screens_count).from(0).to(4)

    lambda do
      s.screens_count = 2
    end.should change(s, :screens_count).to(2)
  end
  
end
