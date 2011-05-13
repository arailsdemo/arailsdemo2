Then /^the new template is used for the home page$/ do
  attributes = Factory.attributes_for(:home_page_view_template)
  visit root_url

  page.should have_content attributes[:source]
end
