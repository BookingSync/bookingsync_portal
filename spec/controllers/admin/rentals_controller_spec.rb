require 'rails_helper'

describe BookingsyncPortal::Admin::RentalsController do
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
    before do
      expect(Rental).to receive(:synchronize).with(scope: account) do
        # pretending to sync rentals :P
        rental
      end
    end

    context "methods from default config" do
      render_views

      it 'synchronizes rentals' do
        expect { get :index }.to change { Rental.count }
      end
    end
    
    context "using custom methods" do
      before do
        BookingsyncPortal.setup do |config|
          config.not_connected_rentals = Proc.new { "not_connected_rentals" }
          config.visible_rentals = Proc.new { "visible_rentals" }
          config.remote_accounts = Proc.new { "remote_accounts" }
          config.remote_rentals_by_account = Proc.new { "remote_rentals_by_account" }
        end
      end

      it "should call custom 'not_connected_rentals' method" do
        get :index
        expect(BookingsyncPortal.not_connected_rentals.call).to eq("not_connected_rentals")
        expect(assigns(:not_connected_rentals)).to eq("not_connected_rentals")
      end

      it "should call custom 'visible_rentals' method" do
        get :index
        expect(BookingsyncPortal.visible_rentals.call).to eq("visible_rentals")
        expect(assigns(:visible_rentals)).to eq("visible_rentals")
      end

      it "should call custom 'remote_accounts' method" do
        get :index
        expect(BookingsyncPortal.remote_accounts.call).to eq("remote_accounts")
        expect(assigns(:remote_accounts)).to eq("remote_accounts")
      end

      it "should call custom 'remote_rentals_by_account' method" do
        get :index
        expect(BookingsyncPortal.remote_rentals_by_account.call).to eq("remote_rentals_by_account")
        expect(assigns(:remote_rentals_by_account)).to eq("remote_rentals_by_account")
      end
    end
  end
end
