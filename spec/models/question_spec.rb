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

  it "should require question" do
    q = FactoryGirl.build :question, :question => " "
    q.should_not be_valid
  end

  it "should require kind" do
    q = FactoryGirl.build :question, :kind => " "
    q.should_not be_valid
  end

  it "should require state" do
    q = FactoryGirl.build :question, :state => " "
    q.should_not be_valid
  end

  it "should be countdownable" do
    q = FactoryGirl.create :question
    q.countdown_to.should == nil
    q.start_countdown 2
    q.countdown_to.should_not == nil
    q.countdown_remaining.should > 0
    q.countdown_remaining.should <= 2
    q.stop_countdown?.should be_false
    sleep 2
    q.stop_countdown
    q.countdown_remaining.should == nil
    q.countdown_to.should == nil
  end

  it "should switch state" do
    q = FactoryGirl.create :question
    q.state.should == "new"
    q.switch_state
    q.state.should == "showed"
    q.switch_state
    q.state.should == "active"
    q.switch_state
    q.state.should == "statistics"
    q.switch_state
    q.state.should == "finished"
    q.switch_state
    q.state.should == "finished"
  end

  context do
    before :each do
      @aw = FactoryGirl.create :answer_variant
      @q = @aw.question
      @s = @q.section
      @aw2 = FactoryGirl.create :answer_variant, :question => @q
      @a = FactoryGirl.create :anonymous, :section => @s
      @a2 = FactoryGirl.create :anonymous, :section => @s
      @a3 = FactoryGirl.create :anonymous, :section => @s
    end
      
      
    it "should reset question" do
      @q.update_attributes :state => "active"
      FactoryGirl.create :vote, :anonymous => @a, :answer_variant => @aw
      FactoryGirl.create :vote, :anonymous => @a2, :answer_variant => @aw2
      @q.reset_state
      @q.state.should == "new"
      @q.answered?.should be_false
      @q.voted_anonymous_count.should == 0
      Vote.joins(:answer_variant).where('answer_variants.question_id' => @q.id).count.should == 0
    end
    
    it "should count voted anonymous" do
      @q.update_attributes :kind => "check"
      @q.voted_anonymous_count.should == 0
      
      lambda do
        FactoryGirl.create :vote, :anonymous => @a, :answer_variant => @aw
      end.should change(@q, :voted_anonymous_count).to(1)

      lambda do
        FactoryGirl.create :vote, :anonymous => @a, :answer_variant => @aw2
      end.should_not change(@q, :voted_anonymous_count)

      v = nil
      lambda do
        v = FactoryGirl.create :vote, :anonymous => @a2, :answer_variant => @aw
      end.should change(@q, :voted_anonymous_count).by(1)

      lambda do
        v.destroy
      end.should change(@q, :voted_anonymous_count).by(-1)

      lambda do
        FactoryGirl.create :vote, :anonymous => @a3, :answer_variant => @aw
        FactoryGirl.create :vote, :anonymous => @a3, :answer_variant => @aw2
      end.should change(@q, :voted_anonymous_count).by(1)
    end
    
    it "should find anonymous voted variants" do
      @q.update_attributes :kind => "check"
      @q.voted_variants(@a).count.should == 0
      FactoryGirl.create :vote, :anonymous => @a, :answer_variant => @aw
      s = Set.new @q.voted_variants(@a).map(&:id)
      ss = Set.new [@aw.id]
      s.should == ss

      v = FactoryGirl.create :vote, :anonymous => @a, :answer_variant => @aw2
      s = Set.new @q.voted_variants(@a).map(&:id)
      ss = Set.new [@aw.id, @aw2.id]
      s.should == ss
      v.destroy

      FactoryGirl.create :vote, :anonymous => @a2, :answer_variant => @aw
      Set.new(@q.voted_variants(@a).map(&:id)).should == Set.new([@aw.id])
    end

    it "should detect if questions answered by anonymous" do
      @q.question_answered?(@a).should be_false

      FactoryGirl.create :vote, :anonymous => @a, :answer_variant => @aw
      @q.question_answered?(@a).should be_true
    end
  end
end
