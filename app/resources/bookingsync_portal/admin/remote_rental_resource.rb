module BookingsyncPortal
  module Admin
    class RemoteRentalResource < JSONAPI::Resource
      model_name BookingsyncPortal.remote_rental_model

      attributes :id

      def self.records(options = {})
        context = options[:context]
        context[:current_account].remote_rentals
      end
    end
  end
end
