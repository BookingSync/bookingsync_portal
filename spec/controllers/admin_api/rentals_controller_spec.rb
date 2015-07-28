require 'rails_helper'

describe BookingsyncPortal::AdminApi::RentalsController do
  routes { BookingsyncPortal::Engine.routes }

  before do
    request.env['HTTPS'] = 'on'
    request.env['CONTENT_TYPE'] = "application/vnd.api+json"
    allow(controller).to receive(:current_account).and_return(account)
  end

  let(:account) { create :account }

  describe 'GET index' do
    let(:rental) { create :rental, account: account }
    before do
      expect(BookingsyncPortal::Rental).to receive(:synchronize).with(scope: account) do
        # pretending to sync rentals :P
        rental
      end
    end

    it 'synchronizes rentals' do
      expect { get :index }.to change { account.rentals.count }.by(1)
    end

    it 'responds with rentals from current account in JSON API format' do
      get :index
      expect(JSON.parse(response.body)["data"]).to eq [
        { "id" => rental.id.to_s,
          "type" => "rentals",
          "links" => { "self" => "https://test.host/en/admin_api/rentals/#{rental.id.to_s}" }
        }
      ]
    end
  end
end