Feature: Creating View Templates
  As the site owner
  I want to create view templates via the web
  So that I can personalize my site

  Scenario: Creating a new valid view template
    Given I am authenticated
    When I create a view template for the home page
    Then the new template is used for the home page