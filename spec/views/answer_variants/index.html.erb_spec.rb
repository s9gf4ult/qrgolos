require 'spec_helper'

describe "answer_variants/index" do
  before(:each) do
    assign(:answer_variants, [
      stub_model(AnswerVariant,
        :question_id => 1,
        :text => "Text",
        :position => 2
      ),
      stub_model(AnswerVariant,
        :question_id => 1,
        :text => "Text",
        :position => 2
      )
    ])
  end

  it "renders a list of answer_variants" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Text".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
  end
end
