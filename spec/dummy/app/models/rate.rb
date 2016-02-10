class Rate < BookingsyncPortal::Rate
  synced remove: true, strategy: :updated_since
end
