require 'spec_helper'

describe User do
  it "should be creatable" do
    x = FactoryGirl.build :user
    x.should be_valid
    r = x.save
    r.should == true
  end

  it "should require email" do
    x = FactoryGirl.build :user, :email => ""
    x.should_not be_valid
  end

  it "should require unique email" do
    x = FactoryGirl.build :user
    y = FactoryGirl.build :user, :email => x.email
    x.save
    y.should_not be_valid
  end

  it "should discard invalid emails" do
    x = FactoryGirl.build :user, :email => "use@asdf"
    x.should_not be_valid
    x.email = "sdf@wrrr.com"
    x.should be_valid
    x.email = "uusdf.com"
    x.should_not be_valid
  end
end
