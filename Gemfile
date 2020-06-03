source 'https://rubygems.org'

ruby '2.4.3'

gem 'rails', '5.1.4'
gem 'bundler', '1.16.1'
gem 'puma', '3.8.0'
gem 'pg', '0.21.0'
gem 'sidekiq'
gem 'sidekiq-cron'
gem 'sidekiq-failures'
gem 'redis', '3.3.3'
gem 'redis-namespace'
gem 'faraday'
gem 'figaro'
gem 'friendly_id'
gem 'immutable-struct'

gem 'nokogiri', '1.8.3'

# Authentication & authorisation
gem 'devise', '4.3.0'
gem 'devise-async', '>= 1.0.0'
gem 'omniauth'
gem 'omniauth-oauth2'
gem 'pundit', require: true

# Rendering
gem 'haml'
gem 'jbuilder'
gem 'sdoc'

# Search
gem 'pg_search'
gem 'kaminari', '>= 1.1.1'
gem 'faraday_middleware-aws-signers-v4'
gem 'elasticsearch-rails'
gem 'elasticsearch-model'
gem 'devise_security_extension', git: 'https://github.com/phatworx/devise_security_extension.git'

# Styling
gem 'bourbon'
gem 'neat', '1.8.0'
gem 'autoprefixer-rails'
gem 'normalize-scss'
gem 'sass-rails', '>= 5.0.7'

# Javascript
gem 'jquery-rails', '>= 4.3.1'
gem 'ckeditor'

# Ruby tools
gem 'stringex', require: false
gem 'addressable'

# ActiveRecord tools
gem 'hairtrigger'
gem 'active_record_union'

# Parsing JSON
gem 'yajl-ruby', '>= 1.3.1'

# Developer tools
gem 'pry-rails'
gem 'premailer-rails', '>= 1.10.1'
gem 'flipper'
gem 'flipper-redis'
gem 'flipper-ui'
gem 'paper_trail'

# aws sdk for s3 storage of post-user communications
gem 'aws-sdk'

# Monitoring
gem 'sentry-raven'

# file uploader
gem 'carrierwave'

# rest client for antivirus scanning
gem 'rest-client'

# zipping for email attachments over 10MB
gem 'rubyzip'

group :development, :test do
  gem 'byebug'
  gem 'pry-rescue'
  gem 'pry-stack_explorer'
  gem 'bullet'
  gem 'uglifier'
end

group :development do
  gem 'web-console', '>= 3.5.1'
  gem 'rubocop', '~> 0.49.0', require: false
  gem 'listen'
end

group :test do
  gem 'capybara', '>= 2.17.0', require: false
  gem 'capybara-email', '>= 2.5.0', require: false
  gem 'capybara-screenshot', '>= 1.0.18'
  gem 'fuubar'
  gem 'shoulda-matchers', require: false
  gem 'rspec-sidekiq'
  gem 'timecop'

  gem 'webmock'
  gem 'rspec-rails', '>= 3.7.2'
  gem 'rspec-collection_matchers'
  gem 'rspec_junit_formatter'
  gem 'pundit-matchers', '>= 1.4.1'
  gem 'database_cleaner'
  gem 'factory_girl_rails', '>= 4.9.0'
  gem 'faker'
  gem 'launchy'
  gem 'poltergeist', '>= 1.17.0'
  gem 'simplecov'
  gem 'vcr'
  gem 'elasticsearch-extensions'
  gem 'show_me_the_cookies', '>= 3.1.0'
  gem 'rails-controller-testing', '>= 1.0.2'
end

group :production do
  gem 'rails_12factor'
end
