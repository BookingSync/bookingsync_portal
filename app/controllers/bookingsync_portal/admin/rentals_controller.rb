module BookingsyncPortal
  module Admin
    class RentalsController < Admin::BaseController
      before_action :resolve_action, only: :index
      before_action :synchronize_rentals, only: :index
      before_action :fetch_remote_rentals, only: :index

      def index
        index_preparation
        @remote_rentals_by_account = @remote_rentals_by_account.group_by(&:remote_account)
      end

      def index_with_search
        synchronize_rentals if !searchable?
        index_preparation

        apply_search
        apply_pagination

        @remote_rentals_by_account = @remote_rentals_by_account.group_by(&:remote_account)
        render :index
      end

      def show
        rental
      end

      private

      def searchable?
        # TODO implement me
        true
      end

      def index_preparation
        @not_connected_rentals = current_account.rentals.visible.ordered.not_connected
        @visible_rentals = current_account.rentals.visible
        @remote_accounts = current_account.remote_accounts
        @remote_rentals_by_account = current_account.remote_rentals.ordered
          .includes(:remote_account, :rental)
      end

      def apply_search
        #TODO implement me
      end

      def apply_pagination
        #TODO implement me
      end

      def synchronize_rentals
        BookingsyncPortal.rental_model.constantize.synchronize(scope: current_account)
      end

      def fetch_remote_rentals
        unless BookingsyncPortal.fetch_remote_rentals(current_account)
          @remote_account_not_registered = true
        end
      end

      def rental
        @rental ||= current_account.rentals.visible.find(params[:id])
      end

      def resolve_action
        redirect_to admin_v2_rentals_path if BookingsyncPortal.use_paginated_view.call(current_account)
      end
    end
  end
end
