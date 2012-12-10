require 'spec_helper'

describe Anonymous do
  it "should have devault fake as false" do
    a = Anonymous.new
    a.fake.should == false
  end

  it "should have default unique aid" do
    a = Anonymous.new
    a.aid.should_not == nil
    Anonymous.where(:aid => a.aid).count.should == 0
  end

  it "should require unique aid" do
    a = FactoryGirl.create :anonymous
    aa = FactoryGirl.build :anonymous, :aid => a.aid
    aa.should_not be_valid
  end

  it "should require unique name and name_number in section" do
    a = FactoryGirl.create :anonymous, :name_number => 1
    aa = FactoryGirl.build :anonymous, :section => a.section, :name_number => a.name_number, :name => a.name
    aa.should_not be_valid

    b = FactoryGirl.create :anonymous, :name => "", :name_number => 1
    bb = FactoryGirl.build :anonymous, :section => b.section, :name => b.name, :name_number => b.name_number
    bb.should_not be_valid
  end

  it "should not fail with same name but name_number is nil" do
    a = FactoryGirl.create :anonymous, :name_number => nil
    aa = FactoryGirl.build :anonymous, :section => a.section, :name => a.name, :name_number => nil
    aa.should be_valid
  end

  it "should require aid" do
    a = FactoryGirl.build :anonymous, :aid => ""
    a.should_not be_valid
  end

  it "formated name should differ when name number is set" do
    a = FactoryGirl.create :anonymous
    aa = FactoryGirl.create :anonymous, :section => a.section, :name => a.name
    aa.actuate_name_number
    a.formated_name.should_not == aa.formated_name
  end
    
end
