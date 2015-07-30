require 'rails_helper'

describe BookingsyncPortal::AdminApi::RemoteRentalsController do
  routes { BookingsyncPortal::Engine.routes }

  before do
    request.env['HTTPS'] = 'on'
    request.env['CONTENT_TYPE'] = "application/vnd.api+json"
    allow(controller).to receive(:current_account).and_return(account)
  end

  let(:account) { create :account }
  let!(:remote_account) { create :remote_account, uid: 85044, account: account }

  describe 'GET index' do
    let(:remote_rental) { create :remote_rental_with_data, remote_account: remote_account }
    before do
      expect(BookingsyncPortal).to receive(:fetch_remote_rentals) do
        # pretending to fetch remote rentals :P
        remote_rental
      end
    end

    it 'synchronizes remote rentals' do
      expect { get :index }.to change { account.remote_rentals.count }.by(1)
    end

    it 'responds with remote rentals from current account in JSON API format' do
      get :index
      expect(JSON.parse(response.body)["data"]).to eq [
        { "id" => remote_rental.id.to_s,
          "type" => "remote-rentals",
          "links" => { "self" => "https://test.host/en/admin_api/remote-rentals/#{remote_rental.id.to_s}" }
        }
      ]
    end
  end
end
