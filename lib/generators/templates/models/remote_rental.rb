class RemoteRental < BookingsyncPortal::RemoteRental
  # Returns the name of this portal rental. Should be easy to identify.
  def name
    uid
  end
end
