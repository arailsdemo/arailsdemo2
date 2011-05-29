Given /^I am authenticated$/ do
  true
end

# Given a view template exists
Given /^an? (.+) exists$/ do |model|
  factory_name = model.gsub(" ", "_")
  instance_variable_set "@#{factory_name}", Factory(factory_name)
end

# "When I submit a view template form with invalid haml"
When /^I submit a (.+) form with (.+)$/ do |model, prefix|
  model = model.gsub(" ", "_")
  factory = prefix.gsub(" ", "_") + "_" + model
  submit_form model, Factory.attributes_for(factory)
end

Then /^I should get an? (.*) error$/ do |type|
  exception = "undefined local variable" if type == "haml"
  page.should have_content I18n.t("mongoid.errors.messages.#{type}", :exception => exception)
end
