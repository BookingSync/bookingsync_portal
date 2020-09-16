module BookingsyncPortal
  module Admin
    class RentalsController < Admin::BaseController
      before_action :resolve_action, only: :index

      helper_method :search_by_core_listings?
      helper_method :search_by_channel_listings?

      def index
        synchronize_core_listings
        prepare_index_variables
      end

      def index_with_search
        prepare_index_variables do
          apply_search
          apply_pagination
        end

        respond_to do |format|
          format.html do
            synchronize_core_listings
            render :index
          end
          format.js # view can be app specific
        end
      end

      def show
        rental
      end

      def on_the_first_channel_listings_page?
        search_filter.channel_listings_page == 1
      end

      def action_variables
        @action_variables ||= {}
      end

      public :current_account

      def search_by_core_listings?
        params[:core_listings_search].present?
      end

      def search_by_channel_listings?
        params[:channel_listings_search].present?
      end

      private

      def resolve_action
        if BookingsyncPortal.use_paginated_view.call(current_account)
          redirect_to admin_v2_rentals_path
        end
      end

      def prepare_index_variables
        @action_variables = OpenStruct.new

        @listings_repository = BookingsyncPortal.listings_repository_proc.call(current_account)

        set_core_listings { @listings_repository.find_core_listings }
        set_available_listings_count { @listings_repository.available_listings_count }

        set_channel_listings { @listings_repository.find_channel_listings }

        set_channel_listing_sections do
          if on_the_first_channel_listings_page?
            @listings_repository.find_channel_listing_sections_with_blank_ones_first
          else
            @listings_repository.find_channel_listing_sections_only_with_listings
          end
        end

        BookingsyncPortal.before_rentals_index_action_filter.call(self)
        yield if block_given?

        set_channel_listings_by_section do
          @listings_repository.group_channel_listings_by_section(@action_variables.channel_listings)
        end

        set_channel_listing_sections do
          if on_the_first_channel_listings_page?
            blank_sections = @action_variables.channel_listing_sections.select do |s|
              s.has_listings == 0
            end

            blank_sections + @action_variables.channel_listings_by_section.keys
          else
            @action_variables.channel_listings_by_section.keys
          end
        end

        BookingsyncPortal.after_rentals_index_action_filter.call(self)
        @action_variables.to_h.each do |variable_name, variable_value|
          instance_variable_set("@#{variable_name}", variable_value)
        end

      end

      def apply_search
        BookingsyncPortal.filter_strategies.each do |strategy|
          set_core_listings do
            strategy.constantize.call(
              account: current_account,
              records: @action_variables.core_listings,
              search_filter: search_filter
            )
          end

          set_channel_listings do
            strategy.constantize.call(
              account: current_account,
              records: @action_variables.channel_listings,
              search_filter: search_filter
            )
          end

          set_channel_listing_sections do
            strategy.constantize.call(
              account: current_account,
              records: @action_variables.channel_listing_sections,
              search_filter: search_filter
            )
          end
        end
      end

      def apply_pagination
        set_core_listings do
          @action_variables.core_listings
            .page(search_filter.core_listings_page)
            .per(BookingsyncPortal.items_per_page)
        end

        set_channel_listings do
          @action_variables.channel_listings
            .page(search_filter.channel_listings_page)
            .per(BookingsyncPortal.items_per_page)
        end
      end

      def synchronize_core_listings
        if BookingsyncPortal.should_synchronize_core_listings
          BookingsyncPortal.core_listing_model.constantize.synchronize(scope: current_account)
        end
      end

      def rental
        @rental ||= current_account.rentals.visible.find(params[:id])
      end

      def search_filter
        @search_filter ||= BookingsyncPortal::SearchFilter.new(params)
      end

      def set_core_listings
        @action_variables.core_listings = search_by_channel_listings? ? [] : yield
      end

      def set_available_listings_count
        @action_variables.available_listings_count = search_by_channel_listings? ? nil : yield
      end

      def set_channel_listings
        @action_variables.channel_listings = search_by_core_listings? ? [] : yield
      end

      def set_channel_listing_sections
        @action_variables.channel_listing_sections = search_by_core_listings? ? [] : yield
      end

      def set_channel_listings_by_section
        @action_variables.channel_listings_by_section = search_by_core_listings? ? {} : yield
      end
    end
  end
end
