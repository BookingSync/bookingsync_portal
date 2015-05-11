require "rails_helper"

describe BookingsyncPortal::AdminApi::BaseController do
  routes { BookingsyncPortal::Engine.routes }

  # jsonapi-resources can't handle abstract controller without resource so test on real one
  controller(BookingsyncPortal::AdminApi::ConnectionsController) do
    def index
      render nothing: true
    end
  end

  let(:account) { create :account }

  before { @request.env['HTTPS'] = 'on' }

  it "redirects to engine authentication path" do
    get :index
    expect(response.body).to include "/auth/bookingsync/?account_id="
  end

  context "when ssl not used" do
    before { @request.env['HTTPS'] = nil }

    it "forces ssl" do
      get :index
      expect(response).to redirect_to 'https://test.host/bookingsync_portal/admin_api/connections'
    end
  end

  context "when X-Frame-Options is set" do
    before do
      allow(controller).to receive(:current_account).and_return(account)
    end

    it "allows to be run in iframe" do
      request.headers['X-Frame-Options'] = 'SAMEORIGIN'
      get :index
      expect(response.headers['X-Frame-Options']).to eq ''
    end
  end

  context "with authenticated account" do
    before do
      allow(controller).to receive(:current_account).and_return(account)
    end

    it "has context set with current_account" do
      expect(controller.send(:context)).to eq(current_account: account)
    end
  end

  it "is JSONAPI::ResourceController controller" do
    expect(controller).to be_kind_of JSONAPI::ResourceController
  end
end
