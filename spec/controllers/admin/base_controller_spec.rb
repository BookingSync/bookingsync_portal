require 'rails_helper'

describe BookingsyncPortal::Admin::BaseController do
  routes { BookingsyncPortal::Engine.routes }

  controller(BookingsyncPortal::Admin::RentalsController) do
    def index
      render text: "index body"
    end
  end

  before do
    request.env['HTTPS'] = 'on'
    allow(controller).to receive(:current_account).and_return(account)
  end

  describe "GET #index" do
    context "with unauthorized account" do
      let(:account) { nil }

      it "redirects to engine authentication path" do
        get :index
        expect(response.body).to include("action=\"/auth/bookingsync\" method=\"post\"")
        expect(response.body).to include("<input type=\"hidden\" name=\"account_id\" value=\"\">")
      end
    end
  end
end
