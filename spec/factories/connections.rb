FactoryGirl.define do
  factory :connection, class: BookingsyncPortal.connection_model do
    rental
    remote_rental { build(:remote_rental, account: @instance.rental.account) }

    trait :canceled do
      canceled_at Time.current
    end

    factory :canceled_connection, traits: [:canceled] 
  end
end
