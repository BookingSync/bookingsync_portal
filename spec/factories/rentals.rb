FactoryGirl.define do
  factory :rental do
    account
    sequence :synced_id
  end
end
