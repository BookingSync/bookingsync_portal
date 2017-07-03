FactoryGirl.define do
  factory :booking do
    transient do
      last_booking_end { bookings.maximum(:end_at) }
      days { rand(14) + 1 }
    end

    start_at do
      time = last_booking_end || Time.zone.now
      time = time.advance(days: rand(4)) if rand(5) == 0
      time.change(hour: 16)
    end

    end_at do
      time = start_at.advance(days: days)
      time.change(hour: 10)
    end

    status "Booked"
  end
end
