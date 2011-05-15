Feature: Creating A Step List
  As a developer
  I want to generate a list of Cucumber steps
  So that I can easily locate a step

  Scenario: Generating output with the 'dry_run' option
    Given existing files with step definitions
    And a custom formatter 'StepListFormatter' is defined
    When I run `cucumber -f StepListFormatter -d`
    Then the terminal alphabetically lists the steps with file line numbers
    And a 'step_list.txt' file is generated with a time stamp
