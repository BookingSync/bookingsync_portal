require 'rails_helper'

describe BookingsyncPortal::Admin::ConnectionsController do
  render_views
  routes { BookingsyncPortal::Engine.routes }

  let!(:account) { create(:account) }
  let!(:remote_account) { create(:remote_account, account: account) }
  let(:rental) { create(:rental, account: account) }

  before do
    request.env['HTTPS'] = 'on'
    allow(controller).to receive(:current_account).and_return(account)
  end

  describe 'POST #create' do
    let!(:rental) { create(:rental, account: account) }

    context "when remote_rental doesn't exist" do
      context "when BookingsyncPortal.create_remote_rental is true" do
        let(:action) do
          post :create, params: { rental_id: rental.id, remote_account_id: remote_account.id }
        end

        before do
          allow(BookingsyncPortal).to receive(:create_remote_rental).and_return(true)
        end

        it "creates remote_rental between on remote account" do
          expect { action }.to change { BookingsyncPortal::RemoteRental.count }.by(1)
          expect(rental.remote_rental.remote_account).to eq remote_account
        end

        it "creates connection between rental and newly created remote rental" do
          expect { action }.to change { BookingsyncPortal::Connection.count }.by(1)
          expect(rental.remote_rental.remote_account).to eq remote_account
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

      context "when BookingsyncPortal.create_remote_rental is false" do
        let(:action) do
          post :create, params: { rental_id: rental.id, remote_account_id: remote_account.id }
        end

        before do
          allow(BookingsyncPortal).to receive(:create_remote_rental).and_return(false)
        end

        it "does not create a new remote_rental" do
          expect {
            expect { action }.to raise_error(ActiveRecord::RecordNotFound)
          }.not_to change { BookingsyncPortal::RemoteRental.count }
        end

        it "does not create a new connection" do
          expect {
            expect { action }.to raise_error(ActiveRecord::RecordNotFound)
          }.not_to change { BookingsyncPortal::Connection.count }
        end
      end
    end

    context "when remote_rental already exists" do
      let!(:remote_rental) { create(:remote_rental, account: account) }
      let(:action) do
        put :create, params: { rental_id: rental.id, remote_rental_id: remote_rental.id }
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
  end

  describe 'DELETE #destroy' do
    let!(:rental) { create(:rental, account: account) }
    let!(:remote_rental) { create(:remote_rental, remote_account: remote_account) }
    let!(:connection) { create :connection }
    let(:action) do
      delete :destroy, params: { id: connection.id }
    end

    context 'when current_account is owner' do
      let(:account) { connection.rental.account }

      it 'allows to destroy connection' do
        expect { action }.to change { BookingsyncPortal::Connection.count }.by(-1)
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
    end
  end
end
