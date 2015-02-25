require 'rails_helper'

describe BookingsyncPortal::Admin::HomeController do
  routes { BookingsyncPortal::Engine.routes }

  let(:account) { create :account }

  before do
    request.env['HTTPS'] = 'on'
    allow(controller).to receive(:current_account).and_return(account)
  end

  describe "GET #show" do
    it "redirects to admin rentals path" do
      get :show
      expect(response).to redirect_to(admin_rentals_path)
    end

    it "works with _bookingsync_account_id param given" do
      get :show, _bookingsync_account_id: 100
      expect(response).to redirect_to(admin_rentals_path)
    end

    context "with unauthorized account" do
      let(:account) { nil }

      it "redirects to engine authentication path" do
        get :show
        expect(response.body).to include "/auth/bookingsync/?account_id="
      end
    end
  end
end
