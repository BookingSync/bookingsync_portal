require 'rails_helper'

describe BookingsyncPortal::BookingMap do
  context "by default" do
    let(:booking_map) { BookingsyncPortal::BookingMap.new(Booking.none) }

    it "sets from to the beginning of the month" do
      expect(booking_map.from).to eq Date.today.beginning_of_month
    end

    it "sets length to 1096" do
      expect(booking_map.length).to eq 1096
    end

    it "sets statuses to as booleans" do
      default_statuses = {
        available:    "0",
        tentative:    "0",
        booked:       "1",
        unavailable:  "1"
      }
      expect(booking_map.statuses).to eq default_statuses
    end

    it "computes :to based on :from and :length" do
      expect(booking_map.to).to eq Date.today.beginning_of_month.advance(days: 1096)
    end

    it "filters bookings to only use the ones within :from and :to" do
      booking_before_map = create(:booking, start_at: "2016-02-01T16:00z",
        end_at: "2016-03-01T10:00z")
      booking_within_map = create(:booking, start_at: "2016-03-01T16:00z",
        end_at: "2016-03-11T10:00z")
      booking_after_map = create(:booking, start_at: "2016-03-11T16:00z",
        end_at: "2016-03-12T10:00z")

      booking_map = BookingsyncPortal::BookingMap.new(Booking.all, from: "2016-03-01", length: 10)
      expect(booking_map.from).to eq "2016-03-01".to_date
      expect(booking_map.length).to eq 10
      expect(booking_map.bookings).to eq [booking_within_map]

      booking_map = BookingsyncPortal::BookingMap.new(Booking.all.to_a, from: "2016-03-01",
        length: 10)
      expect(booking_map.bookings).to eq [booking_within_map]
    end
  end

  describe "#map" do
    let(:unavailable_booking) do
      build(:booking, start_at: "2016-02-29", end_at: "2016-03-04", status: "Unavailable")
    end
    let(:tentative_booking) do
      build(:booking, start_at: "2016-03-04", end_at: "2016-03-05", status: "Tentative")
    end
    let(:booked_booking) do
      build(:booking, start_at: "2016-03-06", end_at: "2016-03-07", status: "Booked")
    end
    let(:booking_map) do
      BookingsyncPortal::BookingMap.new([unavailable_booking, tentative_booking, booked_booking],
        from: "2016-03-01", length: 10)
    end

    it "returns the right map" do
      expect(booking_map.map).to eq "1110010000"
    end
  end

  context "class methods" do
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
end
