Given /^I am authenticated$/ do
  true
end

# Given a view template exists
Given /^an? (.+) exists$/ do |model|
  factory_name = model.gsub(" ", "_")
  instance_variable_set "@#{factory_name}", Factory(factory_name)
end

# "When I create a view template for the home page"
When /^I create an? (.+) (?:for|with(?: the)?) (.+)$/ do |model, factory|
  factory_name = model.gsub(" ", "_")
  valid_attributes = Factory.attributes_for(factory_name)
  submit_form factory_name, valid_attributes
  factory_name.classify.constantize.count.should == 1
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
