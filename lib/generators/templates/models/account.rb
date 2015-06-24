class Account < BookingsyncPortal::Account
  synced id_key: :uid, local_attributes: [:email]

  # Uncomment to add Rails logger
  # def api
  #   @api ||= BookingSync::Engine::APIClient.new(token.token, logger: Rails.logger, account: self)
  # end
end
