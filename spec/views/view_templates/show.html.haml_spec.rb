require 'spec_helper'

describe "view_templates/show.html.haml" do
  before(:each) do
    @view_template = assign(:view_template, stub_model(ViewTemplate,
      :name => "Name",
      :prefix => "Prefix",
      :partial => false,
      :source => "MyText",
      :locale => "Locale",
      :formats => "Formats",
      :handlers => "Handlers"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Prefix/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/false/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/MyText/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Locale/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Formats/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Handlers/)
  end
end
