module BookingsyncPortal
  module FilterStrategies
    class BlankRemoteAccounts < BaseStrategy

      filtered_models BookingsyncPortal.remote_account_model

      def call
        search_settings = {}
        BookingsyncPortal.remote_rentals_search.each do |type, fields|
          remote_account_fields = fields.select {|field| field.include?("remote_account.") }.map {|f| f.gsub("remote_account.", "") }
          search_settings[type] = remote_account_fields if remote_account_fields.present?
        end.compact
        BookingsyncPortal::Searcher.call(query: search_filter.remote_rentals_query, records: records, search_settings: search_settings)
      end
    end
  end
end
