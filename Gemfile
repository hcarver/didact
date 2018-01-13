source 'http://rubygems.org'

gem 'rails', '~>3.1'
gem 'less', '=2.0.7'
gem 'mongoid', '~>2.4.7'

gem 'bson', '= 1.4.0'
gem 'bson_ext', '= 1.4.0'
gem 'mongo'
gem 'devise', '= 2.0'

gem 'thin'

#Omniauth
gem 'authbuttons-rails'
gem "omniauth-facebook"
gem 'omniauth-openid'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', "  ~> 3.2"
  gem 'coffee-rails', "~> 3.1"
  gem 'uglifier'
end

# RMagick for image manipulation
gem "rmagick", "2.12.0", :require => 'RMagick'

# Image file storage
gem 'carrierwave', '0.5.8'
gem 'carrierwave-mongoid', :require => 'carrierwave/mongoid'
gem 'fog', '~> 0.9'

# Client stuff
gem 'jquery-rails'
gem "twitter-bootstrap-rails", "~> 1.4.0"

# For generating nicer URLs
gem 'mongoid_slug', "~> 0.9.0"

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

gem 'rspec-rails', '>= 2.8', :group => [:test, :development]

# For changing between models within Mongoid.
gem 'mongoid_rails_migrations', '0.0.13'

group :test do
  gem 'database_cleaner'
  gem 'watchr'
  gem 'factory_girl_rails'
  gem 'mongoid-rspec'
  gem 'cover_me', '>= 1.2.0'
end
