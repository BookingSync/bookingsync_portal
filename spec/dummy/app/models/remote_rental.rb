class RemoteRental < BookingsyncPortal::RemoteRental
  def self.ransackable_attributes(auth_object = nil)
    column_names
  end

  def self.ransackable_associations(auth_object = nil)
    ["account", "connection", "remote_account", "rental"]
  end
end
