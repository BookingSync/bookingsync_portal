module BookingsyncPortal
  module Admin
    class HomeController < Admin::BaseHTMLController
      def show
        redirect_to admin_rentals_path
      end
    end
  end
end
