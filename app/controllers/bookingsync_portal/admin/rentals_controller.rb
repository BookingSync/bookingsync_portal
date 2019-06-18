module BookingsyncPortal
  module Admin
    class RentalsController < Admin::BaseController
      before_action :resolve_action, only: :index
      before_action :synchronize_rentals, only: :index
      before_action :fetch_remote_rentals, only: :index

      helper_method :search_by_rentals?
      helper_method :search_by_remote_rentals?

      def index
        prepare_index_variables
      end

      def index_with_search
        prepare_index_variables do
          apply_search
          apply_pagination
        end

        respond_to do |format|
          format.html do
            synchronize_rentals
            render :index
          end
          format.js # view can be app specific
        end
      end

      def show
        rental
      end

      private

      def search_by_rentals?
        params[:rentals_search].present?
      end

      def search_by_remote_rentals?
        params[:remote_rentals_search].present?
      end

      def resolve_action
        redirect_to admin_v2_rentals_path if BookingsyncPortal.use_paginated_view.call(current_account)
      end

      def prepare_index_variables
        @not_connected_rentals = current_account.rentals.visible.ordered.not_connected
        @visible_rentals = current_account.rentals.visible
        @remote_rentals = current_account.remote_rentals.ordered
        @remote_accounts = current_account.remote_accounts
        
        @search_filter = BookingsyncPortal::SearchFilter.new(params)

        yield if block_given?

        @remote_rentals_by_account = @remote_rentals
          .includes(*BookingsyncPortal.remote_rentals_by_account_included_tables)
          .group_by(&:remote_account)

        @remote_rentals_by_account.merge!(
          blank_remote_accounts.each_with_object({}) {|remote_account, res| res[remote_account] = []}
        )
        @remote_accounts = @remote_rentals_by_account.keys
      end

      def blank_remote_accounts
        return [] if @search_filter.remote_rentals_query.blank? && @search_filter.remote_rentals_page > 1
        
        result = current_account
          .remote_accounts
          .left_outer_joins(:remote_rentals)
          .where(remote_rentals: { id: nil })

        search_settings = {}
        BookingsyncPortal.remote_rentals_search.each do |type, fields|
          remote_account_fields = fields.select {|field| field.include?("remote_account.") }.map {|f| f.gsub("remote_account.", "") }
          search_settings[type] = remote_account_fields if remote_account_fields.present?
        end.compact
        result = BookingsyncPortal::Searcher.call(query: @search_filter.remote_rentals_query, records: result, search_settings: search_settings)
      end

      def apply_search
        @not_connected_rentals = BookingsyncPortal::Searcher.call(query: @search_filter.rentals_query, records: @not_connected_rentals, search_settings: BookingsyncPortal.rentals_search)
        @remote_rentals = BookingsyncPortal::Searcher.call(query: @search_filter.remote_rentals_query, records: @remote_rentals, search_settings: BookingsyncPortal.remote_rentals_search)
      end

      def apply_pagination
        @not_connected_rentals = @not_connected_rentals.page(@search_filter.rentals_page).per(BookingsyncPortal.items_per_page)
        @remote_rentals = @remote_rentals.page(@search_filter.remote_rentals_page).per(BookingsyncPortal.items_per_page)
      end

      def synchronize_rentals
        BookingsyncPortal.rental_model.constantize.synchronize(scope: current_account)
      end

      def fetch_remote_rentals
        @remote_account_not_registered = true unless BookingsyncPortal.fetch_remote_rentals(current_account)
      end

      def rental
        @rental ||= current_account.rentals.visible.find(params[:id])
      end
    end
  end
end
