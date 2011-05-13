Feature: Creating View Templates
  As the site owner
  I want to create view templates via the web
  So that I can personalize my site

  Background: Logged in
    Given I am authenticated

  Scenario: Creating a new valid view template
    When I create a view template for the home page
    Then the new template is used for the home page

  Scenario: Submitting a duplicate view
    Given a view template exists
    When I attempt to create a duplicate template
    Then I should get a duplicate error