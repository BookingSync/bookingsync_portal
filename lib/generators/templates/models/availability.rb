class Availability < BookingsyncPortal::Availability
 synced local_attributes: [:map, :start_date], remove: true
end
