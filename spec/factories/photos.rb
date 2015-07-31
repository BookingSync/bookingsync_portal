FactoryGirl.define do
  factory :photo, class: BookingsyncPortal.photo_model do
    rental
    sequence(:synced_id) { |n| n }
    sequence(:synced_data) do |n|
      {
        description: { en: "description-#{n}" },
        large_url: "http://www.example.com/photo-large-#{n}.jpg",
        micro_url: "http://www.example.com/photo-micro-#{n}.jpg"
      }
    end
    sequence(:position) { |n| n }
  end
end
