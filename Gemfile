source 'http://rubygems.org'

gem 'rails', '3.0.7'
gem "mongoid", "2.0.1"
gem "bson_ext", "1.3.0"
gem "jquery-rails", "0.2.7"
gem "haml-rails", "0.3.4"
gem "compass", "0.11.1"

group :development, :test do
  gem "rspec-rails", "~>2.6.0"
  gem "capybara", "0.4.0"
  gem "cucumber-rails", "0.4.1"
  gem "launchy", "0.4.0"
  gem "factory_girl_rails", "1.1.beta1", :require => false
  gem 'mongoid-rspec', '1.4.2'
end

group :development do
  gem "spork", "0.9.0.rc3", :require => false
  gem "guard-rspec", "0.3.0", :require => false
  gem "guard-spork", "0.1.10", :require => false
  gem "guard-cucumber", '0.3.0', :require => false
  gem "growl", "1.0.3", :require => false
  gem "guard-cucumber", '0.3.0', :require => false

  gem "rcov", "0.9.9", :require => false
  gem "wirble"
  gem "hirb"
  gem "awesome_print", :require => "ap"
  gem "interactive_editor"
end

platforms :mri_18 do
  gem 'ruby-debug'
  gem "SystemTimer"
end

platforms :mri_19 do
  gem 'linecache19', '0.5.11' # 0.5.12 cannot install on 1.9.1, and 0.5.11 appears to work with both 1.9.1 & 1.9.2
  gem 'ruby-debug19'
  gem 'ruby-debug-base19', RUBY_VERSION == '1.9.1' ? '0.11.23' : '~> 0.11.24'
end