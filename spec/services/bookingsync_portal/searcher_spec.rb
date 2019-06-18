require 'rails_helper'

describe BookingsyncPortal::Searcher do
  describe ".call" do
    subject(:call) { described_class.call(query: query, search_settings: search_settings, records: records) }

    let(:records) { Rental.all }
    let(:search_settings) do
      {
        numeric: %w(synced_id),
        string: %w(synced_data)
      }
    end

    context "when query is synced_id" do
      let(:query) { "1" }

      context "and there is rental with such synced_id" do
        let!(:rental) { create(:rental, synced_id: query) }

        it { is_expected.to contain_exactly(rental) }
      end

      context "and there is no rental with such synced_id" do
        let!(:rental) { create(:rental, synced_id: query.to_i + 1) }

        it { is_expected.to be_blank }
      end
    end

    context "when query is string" do
      let(:query) { "bla-bla" }

      context "and there is rental with such synced_id" do
        let!(:rental) { create(:rental, synced_data: { name: query }) }

        it { is_expected.to contain_exactly(rental) }
      end

      context "and there is no rental with such synced_id" do
        let!(:rental) { create(:rental, synced_data: { name: "zzz" }) }

        it { is_expected.to be_blank }
      end
    end
  end
end
