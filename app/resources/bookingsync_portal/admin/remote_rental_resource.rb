module BookingsyncPortal
  module Admin
    class RemoteRentalResource < JSONAPI::Resource
      attributes :id, :name, :active_yn

      def self.records(options = {})
        context = options[:context]
        context[:current_account].remote_rentals
      end
    end
  end
end
