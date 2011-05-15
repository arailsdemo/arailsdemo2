FIXTURE_PATH = "external_features/support/fixtures"

Given /^existing files with step definitions$/ do
  files = %w{example_steps1 more/example_steps2}
  files.each do |file|
    path = File.expand_path("#{FIXTURE_PATH}/input/#{file}.txt")
    steps = File.read(path)
    write_file("features/step_definitions/#{file}.rb", steps)
  end
end

Given /^a custom formatter 'StepListFormatter' is defined$/ do
  formatter_code = File.read("features/support/step_list_formatter.rb")
  write_file("features/support/step_list_formatter.rb", formatter_code)
end

Then /^the terminal alphabetically lists the steps with file line numbers$/ do
  expected_content = File.read("#{FIXTURE_PATH}/output/step_list_output.txt")
  all_stdout.should match /#{Regexp.escape(expected_content)}/
end

Then /^a 'step_list\.txt' file is generated with a time stamp$/ do
  generated_file = "features/step_definitions/step_list.txt"
  expected_content = File.read("#{FIXTURE_PATH}/output/step_list_output.txt")
  check_file_content(generated_file, /#{Regexp.escape(expected_content)}/, true)

  date = Time.now.strftime("%a %b %d")
  check_file_content(generated_file, /#{date}/, true)  # will fail around midnight
end
