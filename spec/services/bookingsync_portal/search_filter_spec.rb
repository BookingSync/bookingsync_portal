require 'rails_helper'

describe BookingsyncPortal::SearchFilter do
  let(:search_filter) { described_class.new(params) }
  let(:params) do
    {
      core_listings_search: core_listings_search,
      channel_listings_search: channel_listings_search,
    }
  end
  let(:channel_listings_search) { {} }
  let(:core_listings_search) { {} }

  describe "#core_listings_query" do
    subject(:core_listings_query) { search_filter.core_listings_query }

    let(:core_listings_search) { { query: query } }

    context "when query is blank" do
      let(:query) { "" }

      it { is_expected.to be_blank }
    end

    context "when query exists" do
      let(:query) { "bla-bla" }

      it { is_expected.to eq(query) }
    end
  end

  describe "#channel_listings_query" do
    subject(:channel_listings_query) { search_filter.channel_listings_query }

    let(:channel_listings_search) { { query: query } }

    context "when channel_listings_page is blank" do
      let(:query) { "" }

      it { is_expected.to be_blank }
    end

    context "when query exists" do
      let(:query) { "bla-bla" }

      it { is_expected.to eq(query) }
    end
  end

  describe "#core_listings_page" do
    subject(:core_listings_page) { search_filter.core_listings_page }

    let(:core_listings_search) { { page: page } }

    context "when page is blank" do
      let(:page) { "" }

      it { is_expected.to eq(1) }
    end

    context "when page exists" do
      let(:page) { 20 }

      it { is_expected.to eq(page) }
    end

  end

  describe "#channel_listings_page" do
    subject(:channel_listings_page) { search_filter.channel_listings_page }

    let(:channel_listings_search) { { page: page } }

    context "when page is blank" do
      let(:page) { "" }

      it { is_expected.to eq(1) }
    end

    context "when page exists" do
      let(:page) { 20 }

      it { is_expected.to eq(page) }
    end

  end
end
