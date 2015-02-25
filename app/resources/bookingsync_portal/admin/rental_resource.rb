module BookingsyncPortal
  module Admin
    class RentalResource < JSONAPI::Resource
      model_name BookingsyncPortal.rental_model

      attributes :id

      def self.records(options = {})
        context = options[:context]
        context[:current_account].rentals
      end
    end
  end
end
