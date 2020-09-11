FactoryBot.define do
  factory :connection, class: BookingsyncPortal.connection_model do
    rental
    remote_rental { build(:remote_rental, account: rental.account) }
  end
end
