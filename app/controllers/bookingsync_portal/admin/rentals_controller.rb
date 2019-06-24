module BookingsyncPortal
  module Admin
    class RentalsController < Admin::BaseController
      before_action :resolve_action, only: :index

      helper_method :search_by_rentals?
      helper_method :search_by_remote_rentals?

      def index
        synchronize_rentals
        fetch_remote_rentals
        
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
            fetch_remote_rentals
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
        redirect_to admin_v2_rentals_path if use_paginated_view?
      end

      def prepare_index_variables
        @action_variables = OpenStruct.new

        @action_variables.not_connected_rentals = current_account.rentals.visible.ordered.not_connected
        @action_variables.visible_rentals = current_account.rentals.visible
        @action_variables.remote_rentals = current_account.remote_rentals.ordered

        yield if block_given?
        BookingsyncPortal.extend_rentals_index_action.call(current_account, @action_variables, params)

        @action_variables.remote_rentals_by_account = @action_variables.remote_rentals
                                                        .includes(*BookingsyncPortal.remote_rentals_by_account_included_tables)
                                                        .group_by(&:remote_account)

        @action_variables.remote_rentals_by_account = blank_remote_accounts.merge(@action_variables.remote_rentals_by_account)
        @action_variables.remote_accounts = @action_variables.remote_rentals_by_account.keys

        @action_variables.to_h.each do |variable_name, variable_value|
          instance_variable_set("@#{variable_name}", variable_value)
        end
      end

      def blank_remote_accounts
        return {} if search_filter.remote_rentals_query.blank? && search_filter.remote_rentals_page > 1
        
        result = current_account
          .remote_accounts
          .left_outer_joins(:remote_rentals)
          .where(remote_rentals: { id: nil })

        BookingsyncPortal.filter_strategies.each do |strategy|
          result = strategy.constantize.call(account: current_account, records: result, search_filter: search_filter)
        end
        result.each_with_object({}) do |remote_account, res| 
          res[remote_account] = []
        end
      end

      def apply_search
        BookingsyncPortal.filter_strategies.each do |strategy|
          @action_variables.not_connected_rentals = strategy.constantize.call(
            account: current_account, 
            records: @action_variables.not_connected_rentals, 
            search_filter: search_filter
          )
          @action_variables.remote_rentals = strategy.constantize.call(
            account: current_account,
            records: @action_variables.remote_rentals, 
            search_filter: search_filter
          )
        end
      end

      def apply_pagination
        @action_variables.not_connected_rentals = @action_variables.not_connected_rentals.page(search_filter.rentals_page).per(BookingsyncPortal.items_per_page)
        @action_variables.remote_rentals = @action_variables.remote_rentals.page(search_filter.remote_rentals_page).per(BookingsyncPortal.items_per_page)
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

      def search_filter
        @search_filter ||= BookingsyncPortal::SearchFilter.new(params)
      end

      def use_paginated_view?
        BookingsyncPortal.use_paginated_view.call(current_account)
      end
    end
  end
end
