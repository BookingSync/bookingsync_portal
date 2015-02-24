FactoryGirl.define do
  factory :remote_account, class: BookingsyncPortal.remote_account_model do
    account
    sequence :uid
  end
end
