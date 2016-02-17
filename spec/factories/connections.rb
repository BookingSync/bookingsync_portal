FactoryGirl.define do
  factory :connection, class: BookingsyncPortal.connection_model do
    rental
    remote_rental { build(:remote_rental, account: @instance.rental.account) }
  end
end
