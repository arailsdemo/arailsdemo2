require 'spec_helper'

describe "view_templates/edit.html.haml" do
  before(:each) do
    @view_template = assign(:view_template, stub_model(ViewTemplate,
      :name => "MyString",
      :prefix => "MyString",
      :partial => false,
      :source => "MyText",
      :locale => "MyString",
      :formats => "MyString",
      :handlers => "MyString"
    ))
  end

  it "renders the edit view_template form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => view_templates_path(@view_template), :method => "post" do
      assert_select "input#view_template_name", :name => "view_template[name]"
      assert_select "input#view_template_prefix", :name => "view_template[prefix]"
      assert_select "input#view_template_partial", :name => "view_template[partial]"
      assert_select "textarea#view_template_source", :name => "view_template[source]"
      assert_select "input#view_template_locale", :name => "view_template[locale]"
      assert_select "input#view_template_formats", :name => "view_template[formats]"
      assert_select "input#view_template_handlers", :name => "view_template[handlers]"
    end
  end
end
