FactoryGirl.define do
  factory :remote_rental do
    remote_account
    sequence :uid
  end
end
