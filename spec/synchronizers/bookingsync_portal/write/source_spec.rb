require 'rails_helper'

describe BookingsyncPortal::Write::Source do
  let(:account) { create(:account) }
  let(:api) { double }
  let(:synchronizer) { BookingsyncPortal::Write::Source.new(account) }

  describe "#synchronize" do
    before do
      allow(account).to receive(:api).and_return(api)
    end

    context "without existing source on bscore" do
      it "creates source on bscore" do
        expect(BookingsyncPortal).to receive(:source_name).at_least(:once).and_return("portal")
        expect(api).to receive(:sources).and_return([Hashie::Mash.new(name: "other portal")])
        expect(api).to receive(:create_source).with(name: "portal")
        synchronizer.synchronize
      end
    end

    context "with existing source on bscore" do
      it "compares the downcased names and fetches source from bscore" do
        expect(BookingsyncPortal).to receive(:source_name).and_return("portal")
        expect(api).to receive(:sources).and_return([Hashie::Mash.new(name: "PORTAL")])
        expect(api).not_to receive(:create_source)
        synchronizer.synchronize
      end
    end
  end
end
