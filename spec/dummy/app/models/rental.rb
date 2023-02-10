class Rental < BookingsyncPortal::Rental
  synced associations: [:photos, :rates],
    local_attributes: [:position, :published_at],
    include: [:availability],
    delegate_attributes: [:name, :sleeps, :sleeps_max, :bedrooms_count, :bathrooms_count, :surface, :surface_unit]

  def self.ransackable_attributes(auth_object = nil)
    column_names
  end

  def self.ransackable_associations(auth_object = nil)
    ["account", "connection", "photos", "rates", "remote_rental"]
  end
end
