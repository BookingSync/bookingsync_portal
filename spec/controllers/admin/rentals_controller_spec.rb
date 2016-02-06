require 'rails_helper'

describe BookingsyncPortal::Admin::RentalsController do
  routes { BookingsyncPortal::Engine.routes }

  let!(:account) { create(:account) }
  let!(:remote_account) { create(:remote_account, account: account) }
  let(:rental) { create(:rental, account: account) }

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

  describe 'PUT #connect_to_new' do
    let!(:rental) { create(:rental, account: account) }
    let(:action) do
      put :connect_to_new, id: rental.id, remote_account_id: remote_account.id
    end

    context "when BookingsyncPortal.create_remote_rental_from_app is true" do
      before do
        BookingsyncPortal.stub(:create_remote_rental_from_app).and_return(true)
      end

      it "creates remote_rental between on remote account" do
        expect { action }.to change { BookingsyncPortal::RemoteRental.count }.by(1)
        expect(rental.remote_rental.remote_account).to eq remote_account
      end

      it "creates connection between rental and newly created remote rental" do
        expect { action }.to change { BookingsyncPortal::Connection.count }.by(1)
        expect(rental.remote_rental.remote_account).to eq remote_account
      end

      it "calls BookingsyncPortal.remote_rental_created" do
        expect(BookingsyncPortal).to receive(:remote_rental_created)
        action
      end

      context "when only rental does not belong to current account" do
        let!(:rental) { create :rental }

        it "does not allow to connect" do
          expect { action }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end

      context "when both rental and remote account belong to different accounts" do
        let!(:default_remote_account) { create(:remote_account, account:account) }
        let(:different_account) { create :account }
        let!(:remote_account) { create(:remote_account, account: different_account) }
        let!(:rental) { create(:rental, account: different_account) }

        it "does not allow to connect" do
          expect {
            expect { action }.to raise_error(ActiveRecord::RecordNotFound)
          }.not_to change { BookingsyncPortal::RemoteRental.count }
        end
      end
    end

    context "when BookingsyncPortal.create_remote_rental_from_app is false" do
      before do
        BookingsyncPortal.stub(:create_remote_rental_from_app).and_return(false)
      end

      it "returns a 404" do
        expect { action }.to raise_error(ActionController::RoutingError)
      end

      it "does not create a new remote_rental" do
        expect {
          expect { action }.to raise_error(ActionController::RoutingError)
        }.not_to change { BookingsyncPortal::RemoteRental.count }
      end

      it "does not create a new connection" do
        expect {
          expect { action }.to raise_error(ActionController::RoutingError)
        }.not_to change { BookingsyncPortal::Connection.count }
      end

      it "does not calls BookingsyncPortal.remote_rental_created" do
        expect(BookingsyncPortal).not_to receive(:remote_rental_created)
        expect { action }.to raise_error(ActionController::RoutingError)
      end
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

    it "calls BookingsyncPortal.connection_created" do
      expect(BookingsyncPortal).to receive(:connection_created)
      action
    end

    context 'when only remote rental does not belong to current account' do
      let!(:remote_rental) { create :remote_rental }

      it 'does not allow to connect' do
        expect { action }.to raise_error(ActiveRecord::RecordNotFound)
      end

      it "does not calls BookingsyncPortal.connection_created" do
        expect(BookingsyncPortal).not_to receive(:connection_created)
        expect { action }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'when only rental does not belong to current account' do
      let!(:rental) { create :rental }

      it 'does not allow to connect' do
        expect { action }.to raise_error(ActiveRecord::RecordNotFound)
      end

      it "does not calls BookingsyncPortal.connection_created" do
        expect(BookingsyncPortal).not_to receive(:connection_created)
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

      it "does not calls BookingsyncPortal.connection_created" do
        expect(BookingsyncPortal).not_to receive(:connection_created)
        expect { action }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe 'PUT #disconnect' do
    let!(:rental) { create(:rental, account: account) }
    let!(:remote_rental) { create(:remote_rental, remote_account: remote_account) }
    let!(:connection) { create :connection }
    let(:action) do
      put :disconnect, id: connection.rental.id
    end

    context 'when current_account is owner' do
      let(:account) { connection.rental.account }

      it 'allows to destroy connection' do
        expect { action }.to change { BookingsyncPortal::Connection.count }.by(-1)
      end

      it "calls BookingsyncPortal.connection_destroyed" do
        expect(BookingsyncPortal).to receive(:connection_destroyed)
        action
      end
    end

    context 'when current_account is not owner' do
      let(:another_account) { create(:remote_account).account }

      before do
        allow(controller).to receive(:current_account).and_return(another_account)
      end

      it 'does not allow to destroy connection' do
        expect { action }.to raise_error(ActiveRecord::RecordNotFound)
      end

      it "does not calls BookingsyncPortal.connection_destroyed" do
        expect(BookingsyncPortal).not_to receive(:connection_destroyed)
        expect { action }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
