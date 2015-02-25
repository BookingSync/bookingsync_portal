require 'rails_helper'

describe BookingsyncPortal::Admin::RentalsController do
  routes { BookingsyncPortal::Engine.routes }

  let(:account) { create :account }
  let(:rental) { create :rental }

  before do
    request.env['HTTPS'] = 'on'
    allow(controller).to receive(:current_account).and_return(account)
  end

  describe "GET index" do
    before do
      Rental.stub(:synchronize) do
        rental
      end
    end

    it "synchronizes rentals" do
      expect { get :index }.to change { Rental.count }
    end
  end
end
