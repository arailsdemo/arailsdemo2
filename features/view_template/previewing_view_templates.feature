Feature: Previewing View Templates
  So that I can easily create production view templates
  As the site owner
  I want to preview templates in development before going live

  Background: Logged in
    Given I am authenticated

  Scenario: Viewing a template in development
    Given a production layout and template are present for the home page
    When I create a home page template for development
    Then I should see the development template within the production layout on the preview page
    And I should not see the development template on the home page

  Scenario: Viewing a layout in development
    Given a development layout and a production template are present for the home page
    When I visit the preview page for the layout
    Then I should see the production template within the development layout
