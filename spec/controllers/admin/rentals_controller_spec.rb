require 'rails_helper'

describe BookingsyncPortal::Admin::RentalsController do
  routes { BookingsyncPortal::Engine.routes }

  let(:account) { create :account }
  let(:rental) { create :rental }

  before do
    request.env['HTTPS'] = 'on'
    allow(controller).to receive(:current_account).and_return(account)
  end

  describe 'GET #index' do
    before do
      expect(BookingsyncPortal::Rental).to receive(:synchronize).with(scope: account) do
        # pretending to sync rentals :P
        rental
      end
    end

    it 'synchronizes rentals' do
      expect { get :index }.to change { Rental.count }
    end
  end

  describe 'PUT #connect' do
    let!(:rental) { create(:rental, account: account) }
    let!(:remote_rental) { create(:remote_rental, account: account) }
    let(:action) do
      put :connect, id: rental.id, remote_rental_id: remote_rental.id
    end

    it 'creates connection between rental and remote rental' do
      expect { action }.to change { BookingsyncPortal::Connection.count }.by(1)
      expect(rental.remote_rental).to eq remote_rental
    end

    context 'when only remote rental does not belong to current account' do
      let!(:remote_rental) { create :remote_rental }

      it 'does not allow to connect' do
        expect { action }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'when only rental does not belong to current account' do
      let!(:rental) { create :rental }

      it 'does not allow to connect' do
        expect { action }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'when both rental and remote rental belong to different account' do
      let(:different_account) { create :account }
      let!(:remote_rental) { create :remote_rental, account: different_account }
      let!(:rental) { create :rental, account: different_account }

      it 'does not allow to connect' do
        expect { action }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe 'PUT #disconnect' do
    let!(:connection) { create :connection }
    let(:action) do
      put :disconnect, id: connection.rental.id
    end

    context 'when current_account is owner' do
      let(:account) { connection.rental.account }

      it 'allows to destroy connection' do
        expect { action }.to change { BookingsyncPortal::Connection.count }.by(-1)
      end
    end

    context 'when current_account is not owner' do
      let(:account) { create :account }

      it 'does not allow to destroy connection' do
        expect { action }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
