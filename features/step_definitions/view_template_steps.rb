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

Given /^a view template with three previous edits$/ do
  @view_template = Factory(:view_template)
  (1..3).each { |i| @view_template.update_attribute(:source, "This is version ##{i}") }
end

When /^I submit an edit for that view template$/ do
  submit_form @view_template, :source => 'foo'
end

Then /^I should see the last three edits for that view template$/ do
end