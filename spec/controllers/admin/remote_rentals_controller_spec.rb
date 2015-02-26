require 'rails_helper'

describe BookingsyncPortal::Admin::RemoteRentalsController do
  routes { BookingsyncPortal::Engine.routes }

  let(:account) { create :account }
  let!(:remote_account) do
    create :remote_account, uid: 85044, account: account
  end

  before do
    request.env['HTTPS'] = 'on'
    allow(controller).to receive(:current_account).and_return(account)
  end

  describe 'GET index' do
    before do
      BookingsyncPortal.stub(:fetch_remote_rentals) do
        create :remote_rental_with_data, remote_account: remote_account
      end
    end

    it 'synchronizes remote rentals' do
      expect {
        get :index
      }.to change { account.remote_rentals.count }.by(1)
    end

    it 'responds with remote rentals from current account in JSON API format' do
      create(:remote_rental)
      get :index
      expect(JSON.parse(response.body)["remote_rentals"]).to eq [
       {
          "id" => account.remote_rentals[0].id.to_s,
        }
      ]
    end
  end
end
