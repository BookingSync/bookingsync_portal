module BookingsyncPortal
  module AdminApi
    class RemoteRentalResource < JSONAPI::Resource
      model_name BookingsyncPortal.remote_rental_model

      def self.records(options = {})
        context = options[:context]
        context[:current_account].remote_rentals
      end
    end
  end
end
