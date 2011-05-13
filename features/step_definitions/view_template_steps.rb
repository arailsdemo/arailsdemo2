When /^I create a view template for the home page$/ do
  visit new_view_template_path
  fill_in t("view_template.name"), :with => "home"
  fill_in t("view_template.prefix"), :with => "pages"
  fill_in t("view_template.source"), :with => "Mongoid view"
  click_button t("view_template.form.save")
  ViewTemplate.count.should == 1
end

Then /^the new template is used for the home page$/ do
  visit root_url
  page.should have_content "Mongoid view"
end
