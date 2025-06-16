source 'https://rubygems.org'

ruby '2.4.3'

gem 'rails', '7.1.0'
gem 'bundler', '1.16.1'
gem 'puma', '3.8.0'
gem 'pg', '0.21.0'
gem 'sidekiq'
gem 'sidekiq-cron', '>= 1.0.0'
gem 'sidekiq-failures', '>= 1.0.1'
gem 'redis', '3.3.3'
gem 'redis-namespace'
gem 'faraday'
gem 'figaro'
gem 'friendly_id', '>= 5.2.4'
gem 'immutable-struct'

gem 'nokogiri', '1.8.3'

# Authentication & authorisation
gem 'devise', '4.7.0'
gem 'devise-async'
gem 'omniauth', '>= 2.1.0'
gem 'omniauth-oauth2', '>= 1.7.1'
gem 'pundit', '>= 2.0.0', require: true

# Rendering
gem 'haml'
gem 'jbuilder', '>= 2.8.0'
gem 'sdoc', '>= 1.0.0'

# Search
gem 'pg_search', '>= 2.1.3'
gem 'kaminari', '>= 1.2.0'
gem 'faraday_middleware-aws-signers-v4'
gem 'elasticsearch-rails'
gem 'elasticsearch-model', '>= 5.1.0'
gem 'devise_security_extension', git: 'https://github.com/phatworx/devise_security_extension.git'

# Styling
gem 'bourbon'
gem 'neat', '1.8.0'
gem 'autoprefixer-rails'
gem 'normalize-scss'
gem 'sass-rails', '>= 5.0.8'

# Javascript
gem 'jquery-rails', '>= 4.3.2'
gem 'ckeditor'

# Ruby tools
gem 'stringex', require: false
gem 'addressable'

# ActiveRecord tools
gem 'hairtrigger', '>= 0.2.21'
gem 'active_record_union'

# Parsing JSON
gem 'yajl-ruby', '>= 1.3.1'

# Developer tools
gem 'pry-rails'
gem 'premailer-rails', '>= 1.10.3'
gem 'flipper'
gem 'flipper-redis'
gem 'flipper-ui', '>= 1.0.0'
gem 'paper_trail', '>= 10.3.1'

# aws sdk for s3 storage of post-user communications
gem 'aws-sdk'

# Monitoring
gem 'sentry-raven'

# file uploader
gem 'carrierwave', '>= 1.2.3'

# rest client for antivirus scanning
gem 'rest-client'

# zipping for email attachments over 10MB
gem 'rubyzip'

group :development, :test do
  gem 'byebug'
  gem 'pry-rescue'
  gem 'pry-stack_explorer'
  gem 'bullet', '>= 5.7.3'
  gem 'uglifier'
end

group :development do
  gem 'web-console', '>= 3.6.0'
  gem 'rubocop', '~> 0.50.0', require: false
  gem 'listen'
end

group :test do
  gem 'capybara', '>= 2.18.0', require: false
  gem 'capybara-email', '>= 3.0.1', require: false
  gem 'capybara-screenshot', '>= 1.0.19'
  gem 'fuubar'
  gem 'shoulda-matchers', '>= 3.1.3', require: false
  gem 'rspec-sidekiq', '>= 3.1.0'
  gem 'timecop'

  gem 'webmock'
  gem 'rspec-rails', '>= 3.8.0'
  gem 'rspec-collection_matchers'
  gem 'rspec_junit_formatter'
  gem 'pundit-matchers', '>= 1.5.0'
  gem 'database_cleaner'
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'launchy'
  gem 'poltergeist', '>= 1.18.0'
  gem 'simplecov'
  gem 'vcr'
  gem 'elasticsearch-extensions'
  gem 'show_me_the_cookies', '>= 4.0.0'
  gem 'rails-controller-testing', '>= 1.0.3'
end

group :production do
  gem 'rails_12factor'
end
