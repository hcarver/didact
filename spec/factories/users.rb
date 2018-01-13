# Read about factories at http://github.com/thoughtbot/factory_girl
require 'factory_girl'

FactoryGirl.define do
  sequence :name do |n|
    "Test User #{n}" 
  end
 
  sequence :email do |n|
    "user#{n}@example.com" 
  end
 
  factory :user do
    name { FactoryGirl.generate(:name) }
    email { FactoryGirl.generate(:email) }
    password 'password'
  end

end