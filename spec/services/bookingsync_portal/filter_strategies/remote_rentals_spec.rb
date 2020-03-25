require 'rails_helper'

describe BookingsyncPortal::FilterStrategies::RemoteRentals do
  describe ".call" do
    subject(:call) { described_class.call(records: records, search_filter: search_filter) }

    let(:search_filter) { BookingsyncPortal::SearchFilter.new({}) }

    context "when records is RemoteRental based" do
      let(:records) { RemoteRental.all }

      it "delegates logic to searcher" do
        expect(BookingsyncPortal::Searcher).to receive(:call)
        call
      end
    end

    context "when records is not RemoteRental based" do
      let(:records) { Rental.all }

      it "does not delegate logic to searcher and return current records" do
        expect(BookingsyncPortal::Searcher).not_to receive(:call)
        expect(call).to eq(records)
      end
    end
  end
end
