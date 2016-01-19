require 'rails_helper'

describe BookingsyncPortal::Write::Source do
  let(:account) { create(:account) }
  let(:api) { double }
  let(:source) { double }
  let(:synchronizer) { BookingsyncPortal::Write::Source.new(account) }

  describe "#synchronize" do
    context "without existing source on bscore" do
      it "creates source on bscore" do
        expect(synchronizer).to receive(:find_source).at_least(:once).and_return(nil)
        expect(synchronizer).to receive(:create_source).and_return([source])
        synchronizer.synchronize
      end
    end

    context "with existing source on bscore" do
      it "fetches source from bscore" do
        expect(synchronizer).to receive(:find_source).at_least(:once).and_return(source)
        expect(synchronizer).to_not receive(:create_source)
        synchronizer.synchronize
      end
    end
  end
end
