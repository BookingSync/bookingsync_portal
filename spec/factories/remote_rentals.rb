FactoryGirl.define do
  factory :remote_rental do
    remote_account
    sequence :uid
    remote_data(hom_homename: "Name", active_yn: "1")
  end
end
