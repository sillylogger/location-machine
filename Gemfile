source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.2'

# Use Puma as the app server
# I feel bad using this version of puma, revert back to origin once https://github.com/puma/puma/issues/1670 is closed
gem 'puma', github: 'puma/puma'
gem 'rack'

# Use PostgreSQL, full text search, and 
gem 'pg'
gem 'pg_search'
gem 'geokit-rails'

# Active Record pagination
gem 'kaminari'

# Use Google cloud for storage
gem 'google-cloud-storage', require: false

# On-the-fly image processing
gem 'cloudinary', github: 'cloudinary/cloudinary_gem'

# Use SCSS for stylesheets
gem 'sass-rails'
gem 'bourbon', github: 'thoughtbot/bourbon'
gem 'neat', github: 'thoughtbot/neat'
gem 'bitters', github: 'thoughtbot/bitters'

# JS compressor and transpiler
gem 'uglifier'
gem 'webpacker'

# Authentication
gem 'devise', github: 'plataformatec/devise'
gem 'omniauth-facebook', github: 'mkdynamic/omniauth-facebook'

# Best admin system for crud settings & pages
gem 'activeadmin', github: 'gregbell/active_admin'
gem 'paper_trail', github: 'paper-trail-gem/paper_trail'

# Format markdown & currencies
gem 'redcarpet'
gem 'monetize'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

# Performance monitoring
gem 'newrelic_rpm'

# Internationalization
gem 'i18n'
gem 'rails-i18n'
gem 'i18n-active_record', :require => 'i18n/active_record'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  gem 'awesome_print'
  gem 'factory_bot_rails', github: 'thoughtbot/factory_bot_rails'

  %w[rspec-core rspec-expectations rspec-mocks rspec-rails rspec-support].each do |lib|
    gem lib, github: "rspec/#{lib}"
  end
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console'
  gem 'listen'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen'
end

group :test do
  gem 'database_cleaner', github: 'DatabaseCleaner/database_cleaner'

  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', github: 'jnicklas/capybara'
  gem 'selenium-webdriver'
  gem 'webdrivers'
end
