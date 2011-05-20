Feature: Versioning View Templates
  So that I can revert changes to existing view templates
  As the site owner
  I have versions on my templates

  Background: Logged in
    Given I am authenticated

  Scenario: Viewing previous versions
    Given a view template with three previous edits
    When I submit an edit for that view template
    Then I should see the last three edits for that view template
