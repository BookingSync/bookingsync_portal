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
        context "rental.synced_id" do
          let(:remote_rentals_search_query) { "#{rental.synced_id}" }
  
          it "filters remote_rentals but does not filter not_connected_rentals part" do
            index_with_search
            expect(assigns(:not_connected_rentals)).to contain_exactly(rental)
            expect(assigns(:remote_rentals_by_account)).to eq({})
          end
        end
        
        context "rental_connected.synced_id" do
          let(:remote_rentals_search_query) { "#{rental_connected.synced_id}" }

          it "filters remote_rentals but does not filter not_connected_rentals part" do
            index_with_search
            expect(assigns(:not_connected_rentals)).to contain_exactly(rental)
            expect(assigns(:remote_rentals_by_account)).to eq({ 
              remote_account_connected => [remote_rental_connected]
            })
          end
        end
        
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
  end
end
