Then /^the file "([^"]*)" should contain:$/ do |file, content|
  check_file_content(file, content, true)
end

Then /^the file "([^"]*)" should not contain:$/ do |file, content|
  check_file_content(file, content, false)
end
