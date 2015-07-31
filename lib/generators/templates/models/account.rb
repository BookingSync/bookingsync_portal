class Account < BookingsyncPortal::Account
  synced local_attributes: [:email]

  # Uncomment to add Rails logger
  # def api
  #   @api ||= BookingSync::Engine::APIClient.new(token.token, logger: Rails.logger, account: self)
  # end

  # Uncomment to add Rails logger
  # # Used to synchronize accounts using `Account.synchronize(remove: true)`
  # def self.api
  #   BookingSync::API::Client.new(BookingSync::Engine.application_token.token, logger: Rails.logger)
  # end
end
