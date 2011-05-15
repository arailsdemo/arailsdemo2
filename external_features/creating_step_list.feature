Feature: Creating A Step Definition List
  As a developer
  I want to generate a list of Cucumber steps definitions
  So that I can easily locate a step

  Scenario: Generating output with the 'dry_run' option
  Given a file named "features/step_definitions/ex_steps.rb" with:
    """
    Then /^the output should contain all of these:$/ do |table|
      table.raw.flatten.each do |string|
        assert_partial_output(string)
      end
    end
    """
  And a file named "features/step_definitions/foo/bar_steps.rb" with:
    """
    Then /^the example(?:s)? should(?: all)? pass$/ do
      Then %q{the output should contain '0 failures'}
      Then %q{the exit status should be 0}
    end

    When /^(?:|I )follow "([^"]*)"$/ do |link|
      click_link(link)
    end
    """
  #"
  And a file named "features/support/step_list_formatter.rb" with:
    """
    require '../../features/support/step_list_formatter'
    """
  When I run `cucumber -f StepListFormatter -d`
  Then the output should contain:
    """
    _____________________________________________________________
    1) (?:|I )follow "([^"]*)"                   # foo/bar_steps.rb:6
    2) the example(?:s)? should(?: all)? pass    # foo/bar_steps.rb:1
    3) the output should contain all of these:   # ex_steps.rb:1

    0 scenarios
    0 steps
    0m0.000s
    """
  #"
  And the file "features/step_definitions/step_list.txt" should contain:
    """
    _____________________________________________________________
    1) (?:|I )follow "([^"]*)"                   # foo/bar_steps.rb:6
    2) the example(?:s)? should(?: all)? pass    # foo/bar_steps.rb:1
    3) the output should contain all of these:   # ex_steps.rb:1
    """
  #"
  And the file "features/step_definitions/step_list.txt" should match /File generated on/

  And the file "features/step_definitions/step_list.txt" should not contain:
    """
    0 scenarios
    0 steps
    0m0.000s
    """
