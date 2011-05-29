# creating_view_templates.feaure
When /^I create a view template for the home page$/ do
  submit_form :view_template, Factory.attributes_for(:view_template)
end

Then /^the new template is used for the home page$/ do
  attributes = Factory.attributes_for(:home_page_view_template)
  visit root_path

  page.should have_content attributes[:source]
end

When /^I attempt to create a duplicate template$/ do
  whitespace_attributes = Factory.attributes_for(
                            :duplicate_view_template,
                            :partial => :check,
                            :handlers => {:select => "Erb"}
                          )
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
  current_path.should == view_template_path(@view_template)
  @view_template.reload.versions.each do |version|
    page.should have_content version.source
  end
end
######################################################

# versioning_view_templates.feature
When /^I revert to the second most recent view template version$/ do
  visit view_template_path(@view_template)
  @new_source = @view_template.versions.last.source
  within :xpath, '//li[@class="view_template_version"][1]' do
    click_link t.view_template.links.revert
  end
  current_path.should == view_template_path(@view_template)
  page.should have_content t.view_template.flash.notice.updated
end

Then /^that view template should be the most current$/ do
  within "div.view_template_current" do
    page.should have_content @new_source
  end
end

Then /^I should not see the current view template in the versions list$/ do
  within "ul.view_template_versions" do
    page.should_not have_content @new_source
  end
end
######################################################

# previewing_view_templates.feature
Given /^a production layout and template are present for the home page$/ do
  Factory(:pages_layout)
  Factory(:home_page_view_template, :source => "%h2 Production Home Page")
end

When /^I create a home page template for development$/ do
  submit_form :view_template, Factory.attributes_for(
                                :home_page_view_template,
                                :source => "%h2 Development Home Page",
                                :status => { :select => t.view_template.options.status.development }
                              )
  ViewTemplate.count.should == 3
end

Then /^I should see the development template within the production layout on the preview page$/ do
  pending
end

Then /^I should not see the development template on the home page$/ do
  pending
end

# save_and_open_page