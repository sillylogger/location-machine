source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.2'

gem 'rack'

# Use postgresql as the database for Active Record
gem 'pg'

# Use google cloud for storage
gem 'google-cloud-storage', '~> 1.11', require: false

# Use cloudinary for processing variants
gem 'cloudinary', github: 'cloudinary/cloudinary_gem'

# Use Puma as the app server
# gem 'puma', github: 'puma/puma'

# I feel bad using this version of puma, revert back to origin once https://github.com/puma/puma/issues/1670 is closed
gem 'puma', git: 'https://github.com/eric-norcross/puma.git', branch: 'chrome_70_ssl_curve_compatiblity'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
gem 'bourbon', github: 'thoughtbot/bourbon'
gem 'neat', github: 'thoughtbot/neat'
gem 'bitters', github: 'thoughtbot/bitters'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker'

gem 'devise', github: 'plataformatec/devise'
gem 'omniauth-facebook', github: 'mkdynamic/omniauth-facebook'

# Best admin system for crud settings & pages
gem 'activeadmin',            github: 'gregbell/active_admin'
gem 'redcarpet'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

# internationalization
gem 'i18n'
gem 'rails-i18n', '~> 5.1'
gem 'i18n-active_record', :require => 'i18n/active_record'

# format currency
gem 'monetize'

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
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  # Only require appengine if running remote commands,
  # otherwise it will warn about Cloud SDK quotas
  gem 'appengine', require: !ENV['APPENGINE'].nil?
end

group :test do
  gem 'database_cleaner', github: 'bmabey/database_cleaner'

  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', github: 'jnicklas/capybara'
  gem 'selenium-webdriver'

  # Easy installation and use of chromedriver to run system tests with Chrome
  gem 'chromedriver-helper'
end
