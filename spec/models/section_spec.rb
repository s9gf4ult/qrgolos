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

  it "should count answered questions" do
    aw = FactoryGirl.create :answer_variant
    q = aw.question
    s = aw.question.section
    anon = FactoryGirl.create :anonymous, :section => s
    lambda do
      vote = FactoryGirl.create :vote, :anonymous => anon, :answer_variant => aw
      q.update_attributes :state => "finished"
    end.should change(s.answered_questions, :count).from(0).to(1)
  end

  it "should count twitts" do
    an = FactoryGirl.create :anonymous
    s = an.section
    lambda do
      FactoryGirl.create :twitt, :anonymous => an
    end.should change(s.twitts, :count).from(0).to(1)

    lambda do
      FactoryGirl.create :twitt, :anonymous => an
    end.should change(s.twitts, :count).by(1)
    an2 = FactoryGirl.create :anonymous, :section => s
    lambda do
      FactoryGirl.create :twitt, :anonymous => an2
    end.should change(s.twitts, :count).by(1)
  end

  it "should count active_twitts" do
    t = FactoryGirl.create :twitt
    s = t.anonymous.section
    lambda do
      t.update_attributes :state => "active"
    end.should change(s.active_twitts, :count).from(0).to(1)

    lambda do
      tt = FactoryGirl.create :twitt, :state => "active", :anonymous => t.anonymous
    end.should change(s.active_twitts, :count).by(1)
  end

  
  context "active and showed questions" do
    before :each do
      @q1 = FactoryGirl.create :question
      @s = @q1.section
      @q2 = FactoryGirl.create :question, :section => @s
    end
    
    it "should change active question" do
      lambda do
        lambda do
          @s.active_question = @q1
        end.should change(@s, :active_question).from(nil).to(@q1)
        @q1.reload
      end.should change(@q1, :state).from("new").to("active")

      lambda do
        lambda do
          @s.active_question = @q2
        end.should change(@s, :active_question).to(@q2)
        @q2.reload
      end.should change(@q2, :state).from("new").to("active")

      lambda do
        @s.active_question = nil
      end.should change(@s, :active_question).to(nil)
    end

    it "should change showed question" do
      lambda do
        lambda do
          @s.showed_question = @q1
        end.should change(@s, :showed_question).from(nil).to(@q1)
        @q1.reload
      end.should change(@q1, :state).from("new").to("showed")

      lambda do
        lambda do
          @s.showed_question = @q2
        end.should change(@s, :showed_question).to(@q2)
        @q2.reload
      end.should change(@q2, :state).from("new").to("showed")

      lambda do
        @s.showed_question = nil
      end.should change(@s, :showed_question).to(nil)
    end

    it "should change current question" do
      lambda do
        @s.active_question = @q1
      end.should change(@s, :current_question).from(nil).to(@q1)

      lambda do
        @s.showed_question = @q1
      end.should_not change(@s, :current_question)
      
      lambda do
        @s.active_question = @q2
      end.should change(@s, :current_question).to(@q2)
    end

    it "active_question should change state of other questions" do
      @s.active_question = @q1
      lambda do
        @s.active_question = nil
        @q1.reload
      end.should change(@q1, :state).to("finished")

      lambda do
        @s.active_question = @q1
        @q1.reload
      end.should change(@q1, :state).to("active")

      lambda do
        @s.active_question = @q2
        @q1.reload
      end.should change(@q1, :state).to("finished")
    end

    it "showed_question should change state of other questions" do
      @s.showed_question = @q1
      lambda do
        @s.showed_question = nil
        @q1.reload
      end.should change(@q1, :state).to("new")

      lambda do
        @s.showed_question = @q1
        @q1.reload
      end.should change(@q1, :state).to("showed")

      lambda do
        @s.showed_question = @q2
        @q1.reload
      end.should change(@q1, :state).to("new")
    end

    it "should have one active question at the same time" do
      @s.active_question = @q1
      @s.questions.where(:state => "active").count.should == 1
      @s.active_question = @q2
      @s.questions.where(:state => "active").count.should == 1
      @s.active_question = @q1
      @s.questions.where(:state => "active").count.should == 1
      @s.active_question = nil
      @s.questions.where(:state => "active").count.should == 0
    end

    it "should have one showed question at the same time" do
      @s.showed_question = @q1
      @s.questions.where(:state => "showed").count.should == 1
      @s.showed_question = @q2
      @s.questions.where(:state => "showed").count.should == 1
      @s.showed_question = @q1
      @s.questions.where(:state => "showed").count.should == 1
      @s.showed_question = nil
      @s.questions.where(:state => "showed").count.should == 0
    end

  end
end
