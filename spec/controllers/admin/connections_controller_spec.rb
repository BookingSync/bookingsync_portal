require 'rails_helper'

describe BookingsyncPortal::Admin::ConnectionsController do
  routes { BookingsyncPortal::Engine.routes }

  def connection_model
    BookingsyncPortal.connection_model.constantize
  end

  let(:account) { create :account }

  before do
    request.env['HTTPS'] = 'on'
    request.env['CONTENT_TYPE'] = "application/vnd.api+json"
    allow(controller).to receive(:current_account).and_return(account)
  end

  describe "POST create" do
    let!(:rental) { create(:rental, account: account) }
    let!(:remote_rental) { create(:remote_rental, account: account) }

    it "creates connection between rental and remote rental" do
      expect {
        post :create, connections: { rental_id: rental.id,
          remote_rental_id: remote_rental.id }
      }.to change { connection_model.count }.by(1)
      connection = connection_model.last
      expect(connection.rental).to eq rental
      expect(connection.remote_rental).to eq remote_rental
    end

    context "when remote rental does not belong to current account" do
      let!(:remote_rental) { create :remote_rental }

      it "does not allow to connect" do
        expect {
          post :create, connections: { rental_id: rental.id,
            remote_rental_id: remote_rental.id }
        }.not_to change { connection_model.count }
      end
    end

    context "when rental does not belong to current account" do
      let!(:rental) { create :rental }

      it "does not allow to connect" do
        expect {
          post :create, connections: { rental_id: rental.id,
            remote_rental_id: remote_rental.id }
        }.not_to change { connection_model.count }
      end
    end

    context "when rental and remote rental does not belong to current account" do
      let(:different_account) { create :account }
      let!(:remote_rental) { create :remote_rental, account: different_account }
      let!(:rental) { create :rental, account: different_account }

      it "does not allow to connect" do
        expect {
          post :create, connections: { rental_id: rental.id,
            remote_rental_id: remote_rental.id }
        }.not_to change { connection_model.count }
      end
    end
  end

  describe "DELETE destroy" do
    let!(:connection) { create :connection }

    context "when current_account is owner" do
      let(:account) { connection.rental.account }

      it "allows to destroy connection" do
        expect {
          delete :destroy, id: connection.id
        }.to change { connection_model.count }.by(-1)
      end
    end

    context "when current_account is not owner" do
      let(:account) { create :account }

      it "does not allow to destroy connection" do
        expect {
          delete :destroy, id: connection.id
        }.not_to change { connection_model.count }
      end
    end
  end
end
