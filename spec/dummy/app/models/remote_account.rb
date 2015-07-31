class RemoteAccount < BookingsyncPortal::RemoteAccount
  def name
    uid
  end
end
