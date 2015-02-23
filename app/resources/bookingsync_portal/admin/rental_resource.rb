module BookingsyncPortal
  module Admin
    class RentalResource < JSONAPI::Resource
      attributes :id

      def self.records(options = {})
        context = options[:context]
        context[:current_account].rentals
      end
    end
  end
end
