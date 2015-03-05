FactoryGirl.define do
  factory :account, class: BookingsyncPortal.account_model do
    sequence(:uid)
  end
end
