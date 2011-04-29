require 'spec_helper'

describe "view_templates/index.html.haml" do
  before(:each) do
    assign(:view_templates, [
      stub_model(ViewTemplate,
        :name => "Name",
        :prefix => "Prefix",
        :partial => false,
        :source => "MyText",
        :locale => "Locale",
        :formats => "Formats",
        :handlers => "Handlers"
      ),
      stub_model(ViewTemplate,
        :name => "Name",
        :prefix => "Prefix",
        :partial => false,
        :source => "MyText",
        :locale => "Locale",
        :formats => "Formats",
        :handlers => "Handlers"
      )
    ])
  end

  it "renders a list of view_templates" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Prefix".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => false.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Locale".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Formats".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Handlers".to_s, :count => 2
  end
end
