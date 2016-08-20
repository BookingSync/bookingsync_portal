class Rental < BookingsyncPortal::Rental
  synced associations: [:photos, :rates],
    local_attributes: [:position, :published_at],
    include: [:availability],
    delegate_attributes: [:name, :sleeps, :sleeps_max, :bedrooms_count, :bathrooms_count, :surface, :surface_unit]
end
