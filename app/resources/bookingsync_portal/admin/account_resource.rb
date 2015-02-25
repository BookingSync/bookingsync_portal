module BookingsyncPortal
  module Admin
    class AccountResource < JSONAPI::Resource
      model_name BookingsyncPortal.account_model

      attributes :id

      def self.records(options = {})
        context = options[:context]
        context[:current_account]
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
