module BookingsyncPortal
  module AdminApi
    class ConnectionResource < JSONAPI::Resource
      model_name BookingsyncPortal.connection_model

      attributes :id, :rental_id, :remote_rental_id

      def self.records(options = {})
        context = options[:context]
        context[:current_account].connections
      end

      def save
        unless context[:current_account].id == @model.rental.account_id &&
               context[:current_account].id == @model.remote_rental.account.id
          raise JSONAPI::Exceptions::RecordNotFound.new(@model.rental_id)
        end
        super
      end
    end
  end
end
