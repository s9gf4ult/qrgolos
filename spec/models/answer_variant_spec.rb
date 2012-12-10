require 'spec_helper'

describe AnswerVariant do
  it "should reqire text" do
    aw = FactoryGirl.build :answer_variant, :text => ' '
    aw.should_not be_valid
  end

  it "should require position" do
    aw = FactoryGirl.build :answer_variant, :position => ' '
    aw.should_not be_valid
  end

  it "should require unique text within one question" do
    aw = FactoryGirl.create :answer_variant
    aw2 = FactoryGirl.build :answer_variant, :text => aw.text
    aw2.should be_valid
    aw3 = FactoryGirl.build :answer_variant, :text => aw.text, :question => aw.question
    aw3.should_not be_valid
  end

  it "should require unique position within one question" do
    aw = FactoryGirl.create :answer_variant
    aw2 = FactoryGirl.build :answer_variant, :question => aw.question, :position => aw.position
    aw2.should_not be_valid
    aw3 = FactoryGirl.build :answer_variant, :position => aw.position
    aw3.should be_valid
  end

  context do
    before :each do
      @aw = FactoryGirl.create :answer_variant
      q = @aw.question
      @aw2 = FactoryGirl.create :answer_variant, :question => q
      @aw3 = FactoryGirl.create :answer_variant, :question => q
    end

    def qpos(q, aw)
      q.answer_variants.reorder('position asc').index aw
    end

    it "should brind up" do
      q = @aw.question
      pos = qpos(q, @aw3)
      @aw3.bringup
      pos.should > qpos(q, @aw3)
      qpos(q, @aw2).should > qpos(q, @aw3)
    end

    it "should not change position of top element" do
      lambda do
        @aw.bringup
      end.should_not change(@aw, :position)
    end

    it "should bringdown" do
      q = @aw.question
      pos = qpos(q, @aw)
      @aw.bringdown
      pos.should < qpos(q, @aw)
      qpos(q, @aw2).should < qpos(q, @aw)
    end

    it "should not change position of last element" do
      lambda do
        @aw3.bringdown
      end.should_not change(@aw3, :position)
    end

    it "should return unique last_position" do
      lp = @aw2.last_position
      q = @aw2.question
      q.answer_variants.where(:position => lp).count.should == 0
    end
  end
end
