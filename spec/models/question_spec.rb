require 'spec_helper'

describe Question do
  it "should have default 'new' state" do
    q = Question.new
    q.state.should == "new"
  end

  it "should have default 'radio' kind" do
    q = Question.new
    q.kind.should == "radio"
  end

  it "should detect if question answered" do
    aw = FactoryGirl.create :answer_variant
    q = aw.question
    anon = FactoryGirl.create :anonymous, :section => q.section
    v = nil
    lambda do
      v = FactoryGirl.create :vote, :anonymous => anon, :answer_variant => aw
    end.should change(q, :answered?).from(false).to(true)

    lambda do
      v.destroy
    end.should change(q, :answered?).to(false)
  end
end
