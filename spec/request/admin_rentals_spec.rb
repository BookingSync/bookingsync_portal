require "rails_helper"

describe "admin/rentals", type: :request do
  let!(:account) { create(:account) }
  let!(:remote_account) { create(:remote_account, account: account) }

  describe "GET #index" do
    subject(:get_rentals) { get "/admin/rentals", headers: { "HTTPS" => "on" } }

    before do
      allow_any_instance_of(BookingsyncPortal::Admin::RentalsController).to receive(:current_account).and_return(account)
    end

    context "when config's use_paginated_view returns false (default)" do
      it "successfully renders page" do
        get_rentals
        expect(response).to have_http_status :ok
      end
    end

    context "when config's use_paginated_view returns true" do
      around do |example|
        BookingsyncPortal.setup do |config|
          config.use_paginated_view = ->(account) { account.persisted? } # anything as long as returns true
        end
        example.run
        BookingsyncPortal.setup do |config|
          config.use_paginated_view = ->(_account) { false }
        end
      end

      before do
        allow_any_instance_of(BookingsyncPortal::Admin::RentalsController).to receive(:current_account).and_return(account)
      end

      it "successfully renders page" do
        get_rentals
        expect(response).to redirect_to("/admin/v2/rentals")
        follow_redirect!
        expect(response).to have_http_status :ok
      end
    end
  end
end
