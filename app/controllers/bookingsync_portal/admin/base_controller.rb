require 'bookingsync_application/controllers/common_base'

module BookingsyncPortal
  module Admin
    class BaseController < ApplicationController
      helper BookingsyncPortal::Admin::ApplicationHelper
      layout 'bookingsync_portal/admin'
      respond_to :html
      include BookingsyncApplication::Controllers::CommonBase

      before_action :enforce_remote_account!

      private

      def enforce_remote_account!
        redirect_to new_admin_remote_account_path if current_account.remote_accounts.empty?
      end

      def messagebus_channel
        "/account-#{current_account.id}"
      end
      helper_method :messagebus_channel
    end
  end
end
