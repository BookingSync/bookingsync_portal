class Photo < BookingsyncPortal::Photo
  synced local_attributes: [:position], delegate_attributes: [:large_url, :thumb_url],
    remove: true, strategy: :updated_since
end
