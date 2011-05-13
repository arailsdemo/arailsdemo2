Then /^the new template is used for the home page$/ do
  attributes = Factory.attributes_for(:home_page_view_template)
  visit root_url

  page.should have_content attributes[:source]
end

When /^I attempt to create a duplicate template$/ do
  whitespace_attributes = Factory.attributes_for(:duplicate_view_template)
  whitespace_attributes.merge!({:partial => :check, :handlers => {:select => "Erb"}})
  submit_form :view_template, whitespace_attributes

  ViewTemplate.count.should == 1
end
