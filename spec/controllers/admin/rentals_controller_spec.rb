require "rails_helper"

describe BookingsyncPortal::Admin::RentalsController do
  routes { BookingsyncPortal::Engine.routes }

  let!(:account) { create(:account) }
  let!(:remote_account) { create(:remote_account, account: account) }
  let(:rental) { create(:rental, account: account) }
  let!(:rental_connected) { create(:rental, account: account) }
  let!(:connection) { create(:connection, rental: rental_connected) }

  before do
    request.env["HTTPS"] = "on"
    allow(controller).to receive(:current_account).and_return(account)
  end

  describe "GET #index" do
    before do
      expect(Rental).to receive(:synchronize).with(scope: account) do
        # pretending to sync rentals :P
        rental
      end
    end

    context "methods from default config" do
      render_views

      it "synchronizes rentals" do
        expect { get :index }.to change { Rental.count }
      end
    end
    
    context "using custom methods" do
      let(:fake_connected_rental) { create(:rental, account: account) }
      let(:fake_visible_rental) { create(:rental, account: account) }
      let(:fake_remote_account) { create(:remote_account, account: account) }
      let(:fake_remote_rental) { create(:remote_rental, account: account) }

      let(:fake_connected_rentals_value) { [fake_connected_rental] }
      let(:fake_visible_rental_value) { [fake_visible_rental] }
      let(:fake_remote_accounts_value) { [fake_remote_account] }
      let(:fake_remote_rentals_by_account_value) do
        RemoteRental.where(id: fake_remote_rental).includes(:remote_account, :rental).group_by(&:remote_account)
      end

      before do
        BookingsyncPortal.setup do |config|
          config.not_connected_rentals = lambda { |account| fake_connected_rentals_value }
          config.visible_rentals = lambda { |account| fake_visible_rental_value }
          config.remote_accounts = lambda { |account| fake_remote_accounts_value }
          config.remote_rentals_by_account = lambda { |account| fake_remote_rentals_by_account_value }
        end
        
        allow(controller).to receive(:render)
        allow(controller).to receive(:render).with(:index, an_instance_of(Hash))
      end

      it "calls custom methods" do
        get :index

        expect(BookingsyncPortal.not_connected_rentals.call(account)).to eq(fake_connected_rentals_value)
        expect(BookingsyncPortal.visible_rentals.call(account)).to eq(fake_visible_rental_value)
        expect(BookingsyncPortal.remote_accounts.call(account)).to eq(fake_remote_accounts_value)
        expect(BookingsyncPortal.remote_rentals_by_account.call(account)).to eq(fake_remote_rentals_by_account_value)

        expect(controller).to have_received(:render).at_least(1).times do |method, options|
          if method == :index
            expect(options.dig(:locals, :not_connected_rentals)).to eq(fake_connected_rentals_value)
            expect(options.dig(:locals, :visible_rentals)).to eq(fake_visible_rental_value)
            expect(options.dig(:locals, :remote_accounts)).to eq(fake_remote_accounts_value)
            expect(options.dig(:locals, :remote_rentals_by_account)).to eq(fake_remote_rentals_by_account_value)
          end
        end
      end
    end
  end
end
