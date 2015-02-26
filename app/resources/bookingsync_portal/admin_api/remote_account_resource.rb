module BookingsyncPortal
  module AdminApi
    class RemoteAccountResource < JSONAPI::Resource
      model_name BookingsyncPortal.remote_account_model

      attributes :id, :uid

      def self.records(options = {})
        context = options[:context]
        context[:current_account].remote_accounts
      end
    end
  end
end
