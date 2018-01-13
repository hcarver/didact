FactoryGirl.define do
  
  factory :ol do 
    name 'Numbers to 10'
    items [1,2,3,4,5,6,7,8,9,10]
    
    factory :ol_with_user do
      name 'Numbers to 5'
      items ['1', '2', '3', '4', '5']
      association :owner, factory: :user
    end
  end
end
