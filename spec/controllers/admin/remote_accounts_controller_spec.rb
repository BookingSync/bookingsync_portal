require 'rails_helper'

describe BookingsyncPortal::Admin::RemoteAccountsController do
  render_views
  routes { BookingsyncPortal::Engine.routes }

  let(:account) { create :account, synced_source_id: 1 }

  before do
    request.env['HTTPS'] = 'on'
    allow(controller).to receive(:current_account).and_return(account)
  end

  describe 'GET #new' do
    before { get :new }
    it 'just works' do
      expect(assigns(:remote_account)).to be_a_new(BookingsyncPortal::RemoteAccount)
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      let(:action) { post :create, remote_account: attributes_for(:remote_account) }
      it do
        expect{ action }.to change{ BookingsyncPortal::RemoteAccount.count }.by(1)
        expect(response).to redirect_to(admin_rentals_url)
      end

      it "ensures account has assigned synced_source_id" do
        ensure_service = BookingsyncPortal::Write::EnsureSourceExists.new(account)
        expect(BookingsyncPortal::Write::EnsureSourceExists).to receive(:new).and_return(ensure_service)
        expect(ensure_service).to receive(:call)
        action
      end
    end

    context 'with invalid attributes' do
      let(:action) { post :create, remote_account: { uid: nil } }
      it do
        expect{ action }.not_to change{ BookingsyncPortal::RemoteAccount.count }
        expect(response).to render_template(:new)
        expect(assigns(:remote_account).errors[:uid]).to eq ["can't be blank"]
      end
    end
  end
end
