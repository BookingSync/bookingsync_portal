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

      # DISCUSS: how first condition matters? We show blank sections only on the first page even if we search
      def ignore_blank_channel_listing_sections?
        search_filter.channel_listings_query.blank? && search_filter.channel_listings_page > 1
      end

      def action_variables
        @action_variables ||= {}
      end

      public :current_account

      private

      def search_by_core_listings?
        params[:core_listings_search].present?
      end

      def search_by_channel_listings?
        params[:channel_listings_search].present?
      end

      def resolve_action
        if BookingsyncPortal.use_paginated_view.call(current_account)
          redirect_to admin_v2_rentals_path
        end
      end

      def prepare_index_variables
        @action_variables = OpenStruct.new

        @listings_repository = BookingsyncPortal.listings_repository_proc.call(current_account)

        @action_variables.core_listings = @listings_repository.find_core_listings
        @action_variables.available_listings_count = @listings_repository.get_available_listings_count
        @action_variables.channel_listings = @listings_repository.find_channel_listings

        @action_variables.channel_listing_sections = if ignore_blank_channel_listing_sections?
          @listings_repository.find_channel_listing_sections_only_with_listings
        else
          @listings_repository.find_channel_listing_sections_with_blank_ones_first
        end

        BookingsyncPortal.before_rentals_index_action_filter.call(self)
        yield if block_given?

        @action_variables.channel_listings_by_section = @listings_repository.group_channel_listings_by_section(@action_variables.channel_listings)

        if ignore_blank_channel_listing_sections?
          @action_variables.channel_listing_sections = @action_variables.channel_listings_by_section.keys
        else
          sections_with_listings, blank_sections = @action_variables.channel_listing_sections.partition do |s|
            s.has_listings == 1
          end

          sections_with_listings = sections_with_listings.select do |s|
            @action_variables.channel_listings_by_section.keys.include?(s)
          end

          @action_variables.channel_listing_sections = blank_sections + sections_with_listings
        end

        BookingsyncPortal.after_rentals_index_action_filter.call(self)
        @action_variables.to_h.each do |variable_name, variable_value|
          instance_variable_set("@#{variable_name}", variable_value)
        end
      end

      def apply_search
        BookingsyncPortal.filter_strategies.each do |strategy|
          @action_variables.core_listings = strategy.constantize.call(
            account: current_account,
            records: @action_variables.core_listings,
            search_filter: search_filter
          )
          @action_variables.channel_listings = strategy.constantize.call(
            account: current_account,
            records: @action_variables.channel_listings,
            search_filter: search_filter
          )

          @action_variables.channel_listing_sections = strategy.constantize.call(
            account: current_account,
            records: @action_variables.channel_listing_sections,
            search_filter: search_filter
          )
        end
      end

      def apply_pagination
        @action_variables.core_listings = @action_variables.core_listings
          .page(search_filter.core_listings_page)
          .per(BookingsyncPortal.items_per_page)

        @action_variables.channel_listings = @action_variables.channel_listings
          .page(search_filter.channel_listings_page)
          .per(BookingsyncPortal.items_per_page)
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
    end
  end
end
