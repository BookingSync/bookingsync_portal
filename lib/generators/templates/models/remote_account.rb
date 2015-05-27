class RemoteAccount < BookingsyncPortal::RemoteAccount
  # Returns the name of this portal account. Should be easy to identify.
  def name
    uid
  end
end
