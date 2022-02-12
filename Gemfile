source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }
# git_source(:github) do |repo_name|
#   repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
#   "https://github.com/#{repo_name}.git"
# end

ruby '2.4.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.3'
# Use sqlite3 as the database for Active Record
gem 'pg', '~> 0.18'
# Use Puma as the app server
gem 'puma', '~> 4.3'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
gem 'mini_racer', platforms: :ruby
# gem 'therubyracer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  gem 'sunspot_solr', '~> 2.2.7'
  gem 'progress_bar'

  gem 'rb-readline'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  # Easy installation and use of chromedriver to run system tests with Chrome
  gem 'chromedriver-helper'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'jquery-validation-rails'

gem 'devise'
gem 'toastr-rails'
gem 'rails_admin'
gem 'city-state'
gem 'actionmailer'
gem 'unicorn'
gem 'fastercsv'
gem 'spreadsheet'
gem 'roo'
gem 'roo-xls'
#gem 'bootstrap-modal-rails'
gem 'carrierwave', '~> 1.0'
gem 'rmagick'
# gem 'will_paginate'
gem 'rubyzip'
gem 'zip-zip'
gem 'sunspot_rails', '~> 2.2.7'
#gem 'rails3-jquery-autocomplete'
gem 'friendly_id'
gem 'best_in_place'
gem 'shopify_app'
gem 'activerecord-session_store'
gem 'rails-jquery-autocomplete'
gem 'sidekiq'

gem 'solidus', github: 'solidusio/solidus', :branch => 'master'
# gem 'solidus_auth_devise'
gem 'solidus_multi_domain', :git => 'https://github.com/solidusio/solidus_multi_domain', :branch => 'master'
gem "awesome_print"
gem 'rack-cors', :require => 'rack/cors'
