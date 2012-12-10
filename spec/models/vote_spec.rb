require 'spec_helper'

describe Vote do
  it "should require vote" do
    v = FactoryGirl.build :vote, :vote => " "
    v.should_not be_valid
  end

  context do
    before :each do
      @aw = FactoryGirl.create :answer_variant
      @q = @aw.question
      @aw2 = FactoryGirl.create :answer_variant, :question => @q
      @a = FactoryGirl.create :anonymous, :section => @q.section
    end
      
    it "should not accept multiple answer_variants if question.kind is 'radio'" do
      @q.update_attributes :kind => "radio"
      FactoryGirl.create :vote, :anonymous => @a, :answer_variant => @aw
      v = FactoryGirl.build :vote, :anonymous => @a, :answer_variant => @aw2
      v.should_not be_valid
    end
      
    it "should not accept multiple votes by one anonymous to one answer_variant" do
      @q.update_attributes :kind => "check"
      FactoryGirl.create :vote, :anonymous => @a, :answer_variant => @aw
      v = FactoryGirl.build :vote, :anonymous => @a, :answer_variant => @aw
      v.should_not be_valid
    end
    
    it "should not accept if anonymous's section is not a questions's section" do
      an = FactoryGirl.create :anonymous
      v = FactoryGirl.build :vote, :anonymous => an, :answer_variant => @aw
      v.should_not be_valid
    end
  end
  it "should just accept vote = 1 if question.kind is 'radio' or 'check'" do
    ['radio', 'check'].each do |kind|
      v = FactoryGirl.build :vote, :vote => 2
      q = v.answer_variant.question
      q.update_attributes :kind => kind
      v.should_not be_valid
      v.vote = 1
      v.should be_valid
    end
  end
end
