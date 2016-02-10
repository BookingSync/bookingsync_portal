class Account < BookingsyncPortal::Account
  synced local_attributes: [:email], strategy: :updated_since

  def api
    @api ||= BookingSync::Engine::APIClient.new(token.token, logger: Rails.logger, account: self)
  end

  # Used to synchronize accounts using `Account.synchronize(remove: true)`
  def self.api
    BookingSync::API::Client.new(BookingSync::Engine.application_token.token, logger: Rails.logger)
  end
end
