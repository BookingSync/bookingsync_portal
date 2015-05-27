class Account < BookingsyncPortal::Account
  # Uncomment to add Rails logger
  # def api
  #   @api ||= BookingSync::Engine::APIClient.new(token.token, logger: Rails.logger, account: self)
  # end
end
