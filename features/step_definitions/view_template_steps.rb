When /^I create a view template for the home page$/ do
  visit new_view_template_path
  fill_in "Name", :with => "home"
  fill_in "Prefix", :with => "pages"
  fill_in "Source", :with => "Mongoid view"
  click_button "Save"
  ViewTemplate.count.should == 1
end

Then /^the new template is used for the home page$/ do
  visit root_url
  page.should have_content "Mongoid view"
end
