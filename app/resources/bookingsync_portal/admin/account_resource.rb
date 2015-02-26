module BookingsyncPortal
  module Admin
    class AccountResource < JSONAPI::Resource
      model_name BookingsyncPortal.account_model

      attributes :id

      def self.records(options = {})
        context = options[:context]
        context[:current_account]
      end
    end
  end
end
