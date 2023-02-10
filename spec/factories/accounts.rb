FactoryGirl.define do
  factory :account, class: BookingsyncPortal.account_model do
    sequence(:synced_id)
    oauth_access_token { "abc123" }
  end
end
