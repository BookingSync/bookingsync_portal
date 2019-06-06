module BookingsyncPortal
  module Admin
    module V2
      class RentalsController < Admin::BaseController
        before_action :synchronize_rentals, only: :index, if: ->(controller) { controller.request.format.html? }
        before_action :fetch_remote_rentals, only: :index, if: ->(controller) { controller.request.format.html? }

        def index
          render json: { status: :success }
        end

        private

        def synchronize_rentals
          BookingsyncPortal.rental_model.constantize.synchronize(scope: current_account)
        end

        def fetch_remote_rentals
          unless BookingsyncPortal.fetch_remote_rentals(current_account)
            @remote_account_not_registered = true
          end
        end
      end
    end
  end
end
