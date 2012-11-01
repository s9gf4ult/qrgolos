require 'spec_helper'

describe "questions/index" do
  before(:each) do
    assign(:questions, [
      stub_model(Question,
        :section_id => 1,
        :question => "Question",
        :state => "State",
        :kind => "Kind"
      ),
      stub_model(Question,
        :section_id => 1,
        :question => "Question",
        :state => "State",
        :kind => "Kind"
      )
    ])
  end

  it "renders a list of questions" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Question".to_s, :count => 2
    assert_select "tr>td", :text => "State".to_s, :count => 2
    assert_select "tr>td", :text => "Kind".to_s, :count => 2
  end
end
