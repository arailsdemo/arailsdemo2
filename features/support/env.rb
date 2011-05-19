require 'spork'

Spork.prefork do
  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../../config/environment", __FILE__)
  require 'capybara'
  require 'cucumber/rails'

  Capybara.default_selector = :css
  Capybara.save_and_open_page_path = 'tmp/capybara/'

  ActionController::Base.allow_rescue = false

  require 'factory_girl'
  Dir[File.expand_path(File.join(File.dirname(__FILE__),'..','..','spec','factories','*.rb'))].each {|f| require f}

  require 'rspec/mocks'
  require 'rspec/core/expecting/with_rspec'
  require 'rspec/core/formatters/documentation_formatter'
  require 'rspec/core/formatters/base_text_formatter'
  require 'rspec/core/mocking/with_rspec'
  require 'rspec/core/expecting/with_rspec'
  require 'rspec/expectations'
  require 'rspec/matchers'
  require 'active_support/secure_random'
end
