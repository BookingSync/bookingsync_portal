FactoryBot.define do
  factory :account, class: BookingsyncPortal.account_model do
    sequence(:synced_id)
  end
end
