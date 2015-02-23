FactoryGirl.define do
  factory :connection do
    after(:build) do |connection, _evaluator|
      account = create(:account)
      connection.rental ||= build(:rental, account: account)
      connection.remote_rental ||= build(:remote_rental, account: account)
    end
  end
end
