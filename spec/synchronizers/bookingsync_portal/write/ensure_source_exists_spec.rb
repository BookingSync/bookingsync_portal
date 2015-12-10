require 'rails_helper'

describe BookingsyncPortal::Write::EnsureSourceExists do
  let(:account) { create(:account) }
  let(:api) { double }
  let(:source) { double }
  let(:service) { BookingsyncPortal::Write::EnsureSourceExists.new(account) }

  describe "#call" do
    context "account has already assigned synced_source_id" do
      before { allow(account).to receive(:synced_source_id).and_return(1) }

      it "doesn't update source" do
        expect(service).to_not receive(:update_source)
        service.call
      end
    end

    context "account doesn't have synced_source_id assigned" do
      before { allow(account).to receive(:synced_source_id).and_return(nil) }

      it "updates source" do
        expect(service).to receive(:update_source)
        service.call
      end
    end
  end
end
