module BookingsyncPortal
  module Callbacks
    def self.connection_created(connection)
      raise 'missing implementation of BookingsyncPortal::Callbacks.connection_created(connection)'
    end

    def self.connection_destroyed(connection)
      raise 'missing implementation of BookingsyncPortal::Callbacks.connection_destroyed(connection)'
    end

    def self.fetch_remote_rentals(account)
      raise 'missing implementation of BookingsyncPortal::Callbacks.fetch_remote_rentals(account)'
    end
  end
end
