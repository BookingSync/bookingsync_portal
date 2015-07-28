module BookingsyncPortal
  module AdminApi
    class RentalResource < JSONAPI::Resource
      model_name BookingsyncPortal.rental_model

      def self.records(options = {})
        context = options[:context]
        context[:current_account].rentals
      end
    end
  end
end
