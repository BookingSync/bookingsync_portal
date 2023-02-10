class RemoteAccount < BookingsyncPortal::RemoteAccount
  def name
    uid
  end

  def self.ransackable_attributes(auth_object = nil)
    ["account_id", "created_at", "id", "uid", "updated_at"]
  end
end
