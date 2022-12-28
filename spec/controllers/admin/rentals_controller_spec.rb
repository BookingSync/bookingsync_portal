require 'rails_helper'

describe BookingsyncPortal::Admin::RentalsController do
  render_views
  routes { BookingsyncPortal::Engine.routes }

  let!(:account) { create(:account) }
  let!(:remote_account) { create(:remote_account, account: account, uid: 3001) }
  let(:rental) { create(:rental, account: account, synced_id: 1001) }
  let!(:remote_rental) { create(:remote_rental, remote_account: remote_account, uid: 2001) }
  let!(:rental_connected) { create(:rental, account: account, synced_id: 1002) }
  let!(:remote_account_connected) { create(:remote_account, account: account, uid: 3002) }
  let!(:remote_rental_connected) { create(:remote_rental, remote_account: remote_account_connected, uid: 2002) }
  let!(:connection) { create(:connection, rental: rental_connected, remote_rental: remote_rental_connected) }
  let!(:remote_account_empty) { create(:remote_account, account: account, uid: 3003) }

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

    it 'synchronizes rentals' do
      expect { get :index }.to change { Rental.count }
    end
  end

  describe 'GET #index_with_search' do
    subject(:index_with_search) do
      get :index_with_search, params: params, format: request_format
    end

    let(:params) do
      {
        rentals_search: {query: rentals_search_query, page: rentals_search_page},
        remote_rentals_search: {query: remote_rentals_search_query, page: remote_rentals_search_page},
      }
    end
    let(:rentals_search_query) { "" }
    let(:rentals_search_page) { 1 }
    let(:remote_rentals_search_query) { "" }
    let(:remote_rentals_search_page) { 1 }
    let(:request_format) { :html }

    context "when format is js" do
      let(:request_format) { :js }

      it "does not call Rental.synchronize for current_account" do
        expect(Rental).not_to receive(:synchronize).with(scope: account)
        index_with_search
      end
    end

    context "when format is html" do
      let(:request_format) { :html }

      before do
        allow(Rental).to receive(:synchronize).with(scope: account) do
          # pretending to sync rentals :P
          rental
        end
      end

      it "calls Rental.synchronize for current_account" do
        expect(Rental).to receive(:synchronize).with(scope: account)
        index_with_search
      end
    end

    context "when there is rentals_search query" do
      context "and it's empty string" do
        let(:rentals_search_query) { "" }

        it "does not filter rentals" do
          index_with_search
          expect(assigns(:not_connected_rentals)).to contain_exactly(rental)
          expect(assigns(:remote_rentals_by_account)).to eq({
            remote_account_connected => [remote_rental_connected],
            remote_account => [remote_rental],
            remote_account_empty => []
          })
          expect(assigns(:remote_rentals_by_account).first).to eq([remote_account_empty, []])
        end

        context "and goes to the next page" do
          let(:rentals_search_page) { 2 }

          it "appies pagination only for not_connected_rentals" do
            index_with_search
            expect(assigns(:not_connected_rentals)).to be_blank

            expect(assigns(:remote_rentals_by_account)).to eq({
              remote_account_connected => [remote_rental_connected],
              remote_account => [remote_rental],
              remote_account_empty => []
            })
            expect(assigns(:remote_rentals_by_account).first).to eq([remote_account_empty, []])
          end
        end
      end

      context "and it's attempt to filter by" do
        context "rental.synced_id" do
          let(:rentals_search_query) { "#{rental.synced_id}" }

          it "filters not_connected_rentals but does not filter remote_rentals part" do
            index_with_search
            expect(assigns(:not_connected_rentals)).to contain_exactly(rental)
            expect(assigns(:remote_rentals_by_account)).to eq({
              remote_account_connected => [remote_rental_connected],
              remote_account => [remote_rental],
              remote_account_empty => []
            })
            expect(assigns(:remote_rentals_by_account).first).to eq([remote_account_empty, []])
          end
        end

        context "rental_connected.synced_id" do
          let(:rentals_search_query) { "#{rental_connected.synced_id}" }

          it "filters not_connected_rentals but does not filter remote_rentals part" do
            index_with_search
            expect(assigns(:not_connected_rentals)).to be_blank
            expect(assigns(:remote_rentals_by_account)).to eq({
              remote_account_connected => [remote_rental_connected],
              remote_account => [remote_rental],
              remote_account_empty => []
            })
            expect(assigns(:remote_rentals_by_account).first).to eq([remote_account_empty, []])
          end
        end
      end
    end

    context "when there is remote_rentals_search query" do
      context "and it's empty string" do
        let(:remote_rentals_search_query) { "" }

        it "does not filter rentals" do
          index_with_search
          expect(assigns(:not_connected_rentals)).to contain_exactly(rental)
          expect(assigns(:remote_rentals_by_account)).to eq({
            remote_account_connected => [remote_rental_connected],
            remote_account => [remote_rental],
            remote_account_empty => []
          })
          expect(assigns(:remote_rentals_by_account).first).to eq([remote_account_empty, []])
        end

        context "and goes to the next page" do
          let(:remote_rentals_search_page) { 2 }

          it "appies pagination only for remote_rentals" do
            index_with_search
            expect(assigns(:not_connected_rentals)).to contain_exactly(rental)
            expect(assigns(:remote_rentals_by_account)).to be_blank
          end
        end
      end

      context "and it's attempt to filter by" do
        context "remote_account.uid" do
          let(:remote_rentals_search_query) { "#{remote_account.uid}" }

          it "filters remote_rentals but does not filter not_connected_rentals part" do
            index_with_search
            expect(assigns(:not_connected_rentals)).to contain_exactly(rental)
            expect(assigns(:remote_rentals_by_account)).to eq({
              remote_account => [remote_rental]
            })
          end
        end

        context "remote_account_connected.uid" do
          let(:remote_rentals_search_query) { "#{remote_account_connected.uid}" }

          it "filters remote_rentals but does not filter not_connected_rentals part" do
            index_with_search
            expect(assigns(:not_connected_rentals)).to contain_exactly(rental)
            expect(assigns(:remote_rentals_by_account)).to eq({
              remote_account_connected => [remote_rental_connected]
            })
          end
        end

        context "remote_account_empty.uid" do
          let(:remote_rentals_search_query) { "#{remote_account_empty.uid}" }

          it "filters remote_rentals but does not filter not_connected_rentals part" do
            index_with_search
            expect(assigns(:not_connected_rentals)).to contain_exactly(rental)
            expect(assigns(:remote_rentals_by_account)).to eq({
              remote_account_empty => []
            })
          end
        end

      end
    end

    context "when there is before_rentals_index_action_filter setting" do
      let(:rentals_index_action_extention) do
        Proc.new do |controller|
          controller.action_variables.not_connected_rentals = Rental.all
          controller.action_variables.remote_rentals = RemoteRental.all
          controller.action_variables.custom_variable = "BookingSync"
        end
      end

      before do
        BookingsyncPortal.before_rentals_index_action_filter = rentals_index_action_extention
      end

      after do
        BookingsyncPortal.before_rentals_index_action_filter = Proc.new {}
      end

      it "applies extended logic" do
        index_with_search
        expect(assigns(:not_connected_rentals)).not_to eq(Rental.all) # will be overridden
        expect(assigns(:remote_rentals)).not_to eq(RemoteRental.all)  # will be overridden
        expect(assigns(:custom_variable)).to eq("BookingSync")
      end
    end

    context "when there is after_rentals_index_action_filter setting" do
      let(:rentals_index_action_extention) do
        Proc.new do |controller|
          controller.action_variables.not_connected_rentals = Rental.all
          controller.action_variables.remote_rentals = RemoteRental.all
          controller.action_variables.custom_variable = "BookingSync"
        end
      end

      before do
        BookingsyncPortal.after_rentals_index_action_filter = rentals_index_action_extention
      end

      after do
        BookingsyncPortal.after_rentals_index_action_filter = Proc.new {}
      end

      it "applies extended logic" do
        index_with_search
        expect(assigns(:not_connected_rentals)).to eq(Rental.all)
        expect(assigns(:remote_rentals)).to eq(RemoteRental.all)
        expect(assigns(:custom_variable)).to eq("BookingSync")
      end
    end

    context "when there are several remote_rentals belonged to several remote_accounts" do
      let!(:remote_account1) { remote_account }
      let!(:remote_account2) { remote_account_connected }
      let!(:remote_account3) { create(:remote_account, account: account) }

      let!(:remote_rental_11) { remote_rental }
      let!(:remote_rental_21) { remote_rental_connected }
      let!(:remote_rental_31) { create(:remote_rental, remote_account: remote_account3) }

      let!(:remote_rental_12) { create(:remote_rental, remote_account: remote_account1) }
      let!(:remote_rental_22) { create(:remote_rental, remote_account: remote_account2) }
      let!(:remote_rental_32) { create(:remote_rental, remote_account: remote_account3) }

      let!(:remote_rental_13) { create(:remote_rental, remote_account: remote_account1) }
      let!(:remote_rental_23) { create(:remote_rental, remote_account: remote_account2) }
      let!(:remote_rental_33) { create(:remote_rental, remote_account: remote_account3) }

      before do
        allow(BookingsyncPortal).to receive(:items_per_page).and_return(4)
      end

      context "and there is the first page" do
        let(:remote_rentals_search_page) { 1 }

        it "displayes recors in corrent order" do
          index_with_search

          expect(assigns(:not_connected_rentals)).to contain_exactly(rental)
          expect(assigns(:remote_rentals_by_account)).to eq({
            remote_account_empty => [],
            remote_account3 => [remote_rental_31, remote_rental_32, remote_rental_33],
            remote_account2 => [remote_rental_21],
          })
        end
      end

      context "and there is the second page" do
        let(:remote_rentals_search_page) { 2 }

        it "displayes recors in corrent order" do
          index_with_search

          expect(assigns(:not_connected_rentals)).to contain_exactly(rental)
          expect(assigns(:remote_rentals_by_account)).to eq({
            remote_account2 => [remote_rental_22, remote_rental_23],
            remote_account1 => [remote_rental_11, remote_rental_12],
          })
        end
      end

      context "and there is the third page" do
        let(:remote_rentals_search_page) { 3 }

        it "displayes recors in corrent order" do
          index_with_search

          expect(assigns(:not_connected_rentals)).to contain_exactly(rental)
          expect(assigns(:remote_rentals_by_account)).to eq({
            remote_account1 => [remote_rental_13],
          })
        end
      end
    end
  end
end
