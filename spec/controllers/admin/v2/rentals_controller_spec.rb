require 'rails_helper'

describe BookingsyncPortal::Admin::V2::RentalsController do
  render_views
  routes { BookingsyncPortal::Engine.routes }

  let!(:account) { create(:account) }
  let!(:remote_account) { create(:remote_account, account: account) }
  let(:rental) { create(:rental, account: account) }
  let!(:rental_connected) { create(:rental, account: account) }
  let!(:connection) { create(:connection, rental: rental_connected) }

  before do
    request.env['HTTPS'] = 'on'
    allow(controller).to receive(:current_account).and_return(account)
  end

  describe 'GET #index' do
    context 'when request format is html' do
      it 'synchronizes rentals' do
        expect(Rental).to receive(:synchronize).with(scope: account) { rental } # pretending to sync rentals :P
        expect { get :index, format: :html }.to change { Rental.count }
      end
    end

    context 'when request format is not html' do
      it 'does not synchronize rentals' do
        expect(Rental).not_to receive(:synchronize)
        expect { get :index, format: :json }.not_to change { Rental.count }
      end
    end
  end
end
