require 'spec_helper'

describe Meeting do
  before :each do
    @meeting = Meeting.new
  end

  it "should require name" do
    @meeting.name = nil
    @meeting.should_not be_valid
    @meeting.errors.on(:name).should_not be_nil
  end
  
end
