class RemoteRental < BookingsyncPortal::RemoteRental
  def name
    uid
  end
end
