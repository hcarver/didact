# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require 'cover_me'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'mongoid-rspec'
require 'database_cleaner'
  
# https://github.com/RailsApps/rails3-mongoid-devise/wiki/Tutorial Action Mailer setup is on the same page.
# #ADD DEVISE TEST HELPERS #Using Devise, your controllers will often include before_filter
# :authenticate_user! to limit access to signed-in users. Your tests will fail unless a default user is
# created and logs in before each test runs. Devise provides test helpers to make it simple to create and log
# in a default user.

# Requires supporting ruby files with custom matchers and macros, etc, in spec/support/ and its
# subdirectories.

RSpec.configure do |config|
  config.include Mongoid::Matchers
  # #Now you can write controller specs that set up a signed-in user before tests are run.
  config.include Devise::TestHelpers, :type => :controller
  
  # == Mock Framework
  # 
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  # 
  # config.mock_with :mocha config.mock_with :flexmock config.mock_with :rr
  config.mock_with :rspec

  # Clean out the database
  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.orm = "mongoid"
  end

  config.before(:each) do
    DatabaseCleaner.clean
  end
end

OmniAuth.config.add_mock(:google, {
    :uid => '12345',
    :nickname => 'zapnap',
    :email => 'user@gmail.com',
    :extra => {
      :raw_info => {
        :email => 'user@gmail.com'
      }
    }
  })

OmniAuth.config.add_mock(:facebook, {
    :uid => '12345',
    :nickname => 'zapnap',
    :email => 'user@facebook.com',
    :info => {
      :email => 'user@facebook.com'
    }
  })