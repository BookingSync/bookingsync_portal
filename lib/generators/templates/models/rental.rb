class Rental < BookingsyncPortal::Rental
  synced associations: [:photos, :availability, :rates],
    local_attributes: [:position, :published_at],
    delegate_attributes: [:name, :sleeps, :sleeps_max, :bedrooms_count, :bathrooms_count, :surface]
end
