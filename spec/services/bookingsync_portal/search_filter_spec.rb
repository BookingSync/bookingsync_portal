require 'rails_helper'

describe BookingsyncPortal::SearchFilter do
  let(:search_filter) { described_class.new(params) }
  let(:params) do
    {
      rentals_search: rentals_search,
      remote_rentals_search: remote_rentals_search,
    }
  end
  let(:remote_rentals_search) { {} }
  let(:rentals_search) { {} }

  describe "#rentals_query" do
    subject(:rentals_query) { search_filter.rentals_query }
    
    let(:rentals_search) { { query: query } }

    context "when query is blank" do
      let(:query) { "" }

      it { is_expected.to be_blank }
    end

    context "when query exists" do
      let(:query) { "bla-bla" }
      
      it { is_expected.to eq(query) }
    end
  end

  describe "#remote_rentals_query" do
    subject(:remote_rentals_query) { search_filter.remote_rentals_query }

    let(:remote_rentals_search) { { query: query } }

    context "when remote_rentals_page is blank" do
      let(:query) { "" }

      it { is_expected.to be_blank }
    end

    context "when query exists" do
      let(:query) { "bla-bla" }
      
      it { is_expected.to eq(query) }
    end
  end

  describe "#rentals_page" do
    subject(:rentals_page) { search_filter.rentals_page }

    let(:rentals_search) { { page: page } }
    
    context "when page is blank" do
      let(:page) { "" }

      it { is_expected.to eq(1) }
    end

    context "when page exists" do
      let(:page) { 20 }

      it { is_expected.to eq(page) }
    end

  end

  describe "#remote_rentals_page" do
    subject(:remote_rentals_page) { search_filter.remote_rentals_page }

    let(:remote_rentals_search) { { page: page } }
    
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
