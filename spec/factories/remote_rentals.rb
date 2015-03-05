FactoryGirl.define do
  factory :remote_rental, class: BookingsyncPortal.remote_rental_model do
    remote_account
    sequence :uid

    factory :remote_rental_with_data do
      remote_data { { home_id: 280769, hom_homename: 'Waterfront', active_yn: 1 }  }
    end
  end
end
