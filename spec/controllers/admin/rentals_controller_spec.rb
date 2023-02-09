require 'rails_helper'

describe BookingsyncPortal::Admin::RentalsController do
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
    context "with default synchronization" do
      before do
        expect(Rental).to receive(:synchronize).with(scope: account) do
          # pretending to sync rentals :P
          rental
        end
      end

      it 'synchronizes rentals' do
        expect { get :index }.to change { Rental.count }
      end
    end

    context 'with custom synchronization action' do
      let(:observer) { [] }
      let(:custom_proc) { ->(account) { observer << account } }

      around do |example|
        original_lambda = BookingsyncPortal.rentals_synchronizer
        BookingsyncPortal.rentals_synchronizer = custom_proc
        example.call
        BookingsyncPortal.rentals_synchronizer = original_lambda
      end

      it 'skips inline rentals sync' do
        expect(Rental).not_to receive(:synchronize)
        expect { get :index }.not_to change { Rental.count }
      end

      it 'runs custom proc' do
        expect { get :index }.to change { observer }.from([]).to([account])
      end
    end
  end
end
