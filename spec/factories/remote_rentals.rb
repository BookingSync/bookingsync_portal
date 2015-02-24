FactoryGirl.define do
  factory :remote_rental, class: BookingsyncPortal.remote_rental_model do
    remote_account
    sequence :uid
  end
end
