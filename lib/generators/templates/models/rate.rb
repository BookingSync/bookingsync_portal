class Rate < BookingsyncPortal::Rate
  synced delegate_attributes: [:name], remove: true
end
