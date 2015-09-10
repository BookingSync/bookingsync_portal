require 'rails_helper'

describe BookingsyncPortal::BookingMap do

  describe ".diff" do
    context "source and destination have different size" do
      let(:source)      { "0011000"}
      let(:destination) { "001100" }

      it "raises error" do
        expect {
          BookingsyncPortal::BookingMap.diff(source, destination)
        }.to raise_error BookingsyncPortal::BookingMap::InvalidLength
      end
    end

    context "source and destination have the same size" do
      context "source and destination are equal" do
        let(:source)      { "0011000" }
        let(:destination) { "0011000" }

        it "returns all underscores (nothing changed)" do
          expect(BookingsyncPortal::BookingMap.diff(source, destination)).to eq "_______"
        end
      end

      context "source contains bookings that destination doesn't have" do
        let(:source)      { "0011011" }
        let(:destination) { "0011000" }

        it "replaces diff booked days with 1 (create)" do
          expect(BookingsyncPortal::BookingMap.diff(source, destination)).to eq "_____11"
        end
      end

      context "destination contains bookings that source doesn't have" do
        let(:source)      { "0011000" }
        let(:destination) { "0011011" }

        it "replaces diff booked days with 0 (destroy)" do
          expect(BookingsyncPortal::BookingMap.diff(source, destination)).to eq "_____00"
        end
      end
    end
  end

  describe ".extract_ranges" do
    let(:map) { "0001000" }
    let(:from) { Date.new(2015, 9, 1) }

    it "extracts availability ranges array" do
      expect(
        BookingsyncPortal::BookingMap.extract_ranges(map, from)
      ).to eq([
        { start_at: Date.new(2015, 9, 1), end_at: Date.new(2015, 9, 4), status: "0" },
        { start_at: Date.new(2015, 9, 4), end_at: Date.new(2015, 9, 5), status: "1" },
        { start_at: Date.new(2015, 9, 5), end_at: Date.new(2015, 9, 8), status: "0" }
      ])
    end

    context "diff map contains no changes" do
      it "returns an empty array" do
        expect(
          BookingsyncPortal::BookingMap.extract_ranges("____", from)
        ).to be_empty
      end
    end
  end
end
