Given /^I am authenticated$/ do
  true
end

# "When I create a view template for the home page"
When /^I create an? (.+) (?:for|with(?: the)?) (.+)$/ do |model, factory|
  factory_name = model.gsub(" ", "_")
  valid_attributes = Factory.attributes_for(factory_name)
  submit_form factory_name, valid_attributes
  factory_name.classify.constantize.count.should == 1
end
