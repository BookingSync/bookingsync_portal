require 'rails_helper'

describe BookingsyncPortal::Admin::HelpController do
  render_views
  routes { BookingsyncPortal::Engine.routes }

  let!(:account) { create :account }
  let!(:remote_account) { create(:remote_account, account: account) }

  before do
    request.env['HTTPS'] = 'on'
    allow(controller).to receive(:current_account).and_return(account)
  end

  describe 'GET #index' do
    it "renders" do
      get :index
      expect(response).to render_template(:index)
    end
  end
end
