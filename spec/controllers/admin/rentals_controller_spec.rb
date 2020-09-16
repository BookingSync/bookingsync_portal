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
  let!(:remote_account_empty) { create(:remote_account, account: account, uid: 1234) }

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

    let(:params) { core_listings_search.merge(channel_listings_search) }

    let(:core_listings_search) { {} }
    let(:channel_listings_search) { {} }
    let(:request_format) { :html }

    context "when format is js" do
      let(:request_format) { :js }

      it "does not call Rental.synchronize" do
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

      it "calls Rental.synchronize" do
        expect(Rental).to receive(:synchronize).with(scope: account)
        index_with_search
      end
    end

    context "when there is core listings search query" do
      let(:core_listings_search) do
        {
          core_listings_search: {
            query: core_listings_search_query,
            page: core_listings_search_page
          }
        }
      end
      let(:core_listings_search_page) { 1 }
      let(:core_listings_search_query) { "" }

      context "and it's an empty string" do
        it "does not filter core listings" do
          index_with_search
          expect(assigns(:core_listings)).to contain_exactly(rental)
          expect(assigns(:channel_listings_by_section)).to be_empty
          expect(assigns(:channel_listing_sections)).to be_empty
        end

        context "and goes to the next page" do
          let(:core_listings_search_page) { 2 }

          it "applies pagination only for core listings" do
            index_with_search
            expect(assigns(:core_listings)).to be_empty
            expect(assigns(:channel_listings_by_section)).to be_empty
            expect(assigns(:channel_listing_sections)).to be_empty
          end
        end
      end

      context "and it's attempt to filter by" do
        context "rental.synced_id" do
          let(:core_listings_search_query) { "#{rental.synced_id}" }

          it "filters core listings but does not filter channel listings part" do
            index_with_search
            expect(assigns(:core_listings)).to contain_exactly(rental)
            expect(assigns(:channel_listings_by_section)).to be_empty
            expect(assigns(:channel_listing_sections)).to be_empty
          end
        end

        context "rental_connected.synced_id" do
          let(:core_listings_search_query) { "#{rental_connected.synced_id}" }

          it "filters core listings but does not filter channel listings part" do
            index_with_search
            expect(assigns(:core_listings)).to be_blank
            expect(assigns(:channel_listings_by_section)).to be_empty
            expect(assigns(:channel_listing_sections)).to be_empty
          end
        end
      end
    end

    context "when there is channel listings search query" do
      let(:channel_listings_search) do
        {
          channel_listings_search: {
            query: channel_listings_search_query,
            page: channel_listings_search_page
          }
        }
      end

      let(:channel_listings_search_query) { "" }
      let(:channel_listings_search_page) { 1 }

      context "and it's an empty string" do
        it "does not filter core listings" do
          index_with_search
          expect(assigns(:core_listings)).to be_empty
          expect(assigns(:channel_listings_by_section)).to eq({
            remote_account_connected => [remote_rental_connected],
            remote_account => [remote_rental]
          })
          expect(assigns(:channel_listing_sections)).to eq([
            remote_account_empty,
            remote_account_connected,
            remote_account
          ])
        end

        context "and goes to the next page" do
          let(:channel_listings_search_page) { 2 }

          it "applies pagination only for channel listings" do
            index_with_search
            expect(assigns(:core_listings)).to be_empty
            expect(assigns(:channel_listings_by_section)).to be_empty
            expect(assigns(:channel_listing_sections)).to be_empty
          end
        end
      end

      context "and it's attempt to filter by" do
        context "remote_account.uid" do
          let(:channel_listings_search_query) { "#{remote_account.uid}" }

          it "filters channel listings but does not filter core listings part" do
            index_with_search
            expect(assigns(:core_listings)).to be_empty
            expect(assigns(:channel_listings_by_section)).to eq({
              remote_account => [remote_rental]
            })
            expect(assigns(:channel_listing_sections)).to eq([
              remote_account
            ])
          end
        end

        context "remote_account_connected.uid" do
          let(:channel_listings_search_query) { "#{remote_account_connected.uid}" }

          it "filters channel listings but does not filter core listings part" do
            index_with_search
            expect(assigns(:core_listings)).to be_empty
            expect(assigns(:channel_listings_by_section)).to eq({
              remote_account_connected => [remote_rental_connected]
            })
            expect(assigns(:channel_listing_sections)).to eq([
              remote_account_connected
            ])
          end
        end

        context "remote_account_empty.uid" do
          let(:channel_listings_search_query) { "#{remote_account_empty.uid}" }

          it "filters channel listings but does not filter core listings part" do
            index_with_search
            expect(assigns(:core_listings)).to be_empty
            expect(assigns(:channel_listings_by_section)).to be_empty
            expect(assigns(:channel_listing_sections)).to eq([
              remote_account_empty
            ])
          end
        end
      end
    end

    context "when there is before_rentals_index_action_filter setting" do
      let(:rentals_index_action_extention) do
        Proc.new do |controller|
          controller.action_variables.core_listings = Rental.all
          controller.action_variables.channel_listings = RemoteRental.all
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
        expect(assigns(:core_listings)).not_to eq(Rental.all) # will be overridden
        expect(assigns(:channel_listings)).not_to eq(RemoteRental.all)  # will be overridden
        expect(assigns(:custom_variable)).to eq("BookingSync")
      end
    end

    context "when there is after_rentals_index_action_filter setting" do
      let(:rentals_index_action_extention) do
        Proc.new do |controller|
          controller.action_variables.core_listings = Rental.all
          controller.action_variables.channel_listings = RemoteRental.all
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
        expect(assigns(:core_listings)).to eq(Rental.all)
        expect(assigns(:channel_listings)).to eq(RemoteRental.all)
        expect(assigns(:custom_variable)).to eq("BookingSync")
      end
    end

    context "when there are several channel listings inside several sections" do
      let!(:remote_account1) { remote_account }
      let!(:remote_account2) { remote_account_connected }
      let!(:remote_account3) { create(:remote_account, account: account) }

      let!(:remote_rental_11) { remote_rental }
      let!(:remote_rental_21) { remote_rental_connected }
      let!(:remote_rental_31) { create(:remote_rental, remote_account: remote_account3, uid: "123") }

      let!(:remote_rental_12) { create(:remote_rental, remote_account: remote_account1, uid: "456") }
      let!(:remote_rental_22) { create(:remote_rental, remote_account: remote_account2, uid: "124") }
      let!(:remote_rental_32) { create(:remote_rental, remote_account: remote_account3, uid: "125") }

      let!(:remote_rental_13) { create(:remote_rental, remote_account: remote_account1, uid: "126") }
      let!(:remote_rental_23) { create(:remote_rental, remote_account: remote_account2, uid: "127") }
      let!(:remote_rental_33) { create(:remote_rental, remote_account: remote_account3, uid: "128") }

      let(:params) do
        {
          channel_listings_search: {
            page: channel_listings_search_page
          }
        }
      end

      before do
        allow(BookingsyncPortal).to receive(:items_per_page).and_return(4)
      end

      context "and there is the first page" do
        let(:channel_listings_search_page) { 1 }

        it "displays records in correct order" do
          index_with_search

          expect(assigns(:core_listings)).to be_empty
          expect(assigns(:channel_listings_by_section)).to eq({
            remote_account3 => [remote_rental_33, remote_rental_32, remote_rental_31],
            remote_account2 => [remote_rental_23],
          })
          expect(assigns(:channel_listing_sections)).to eq([
            remote_account_empty,
            remote_account3,
            remote_account2
          ])
        end
      end

      context "and there is the second page" do
        let(:channel_listings_search_page) { 2 }

        it "displays records in correct order" do
          index_with_search

          expect(assigns(:core_listings)).to be_empty
          expect(assigns(:channel_listings_by_section)).to eq({
            remote_account2 => [remote_rental_22, remote_rental_21],
            remote_account1 => [remote_rental_13, remote_rental_12],
          })
          expect(assigns(:channel_listing_sections)).to eq([
            remote_account2,
            remote_account1
          ])
        end
      end

      context "and there is the third page" do
        let(:channel_listings_search_page) { 3 }

        it "displays records in correct order" do
          index_with_search

          expect(assigns(:core_listings)).to be_empty
          expect(assigns(:channel_listings_by_section)).to eq({
            remote_account1 => [remote_rental_11],
          })
          expect(assigns(:channel_listing_sections)).to eq([
            remote_account1
          ])
        end
      end
    end
  end
end
