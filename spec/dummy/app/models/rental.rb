class Rental < BookingsyncPortal::Rental
  synced associations: [:photos, :rates],
    local_attributes: [:position, :published_at],
    include: [:availability],
    strategy: :updated_since,
    delegate_attributes: [:name, :sleeps, :sleeps_max, :bedrooms_count, :bathrooms_count, :surface]
end
