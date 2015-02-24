FactoryGirl.define do
  factory :rental, class: BookingsyncPortal.rental_model do
    account
    sequence :synced_id
  end
end
