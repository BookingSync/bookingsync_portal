class BookingsyncPortal::BookingMap
  class InvalidLength < StandardError
  end

  attr_reader :bookings, :statuses, :from, :to, :length

  def initialize(bookings, options = {})
    @from = options.fetch(:from) { Date.today.beginning_of_month }
    @from = @from.to_date

    @length = options.fetch(:length) { 1096 }
    @to = @from.advance(days: @length.to_i)
    @statuses = options.fetch(:statuses) { {
      available:    "0",
      tentative:    "0",
      booked:       "1",
      unavailable:  "1"
    } }
    @bookings = bookings_for_map(bookings, @from, @to)
  end

  def map
    days = get_days_hash(from, to, statuses[:available].to_s)

    bookings.each do |booking|
      (booking.start_at.to_date...booking.end_at.to_date).each do |day|
        if day >= from && day <= to
          days[day] = statuses[booking.status.downcase.to_sym]
        end
      end
    end
    days.values.join
  end

  class << self
    # Diff maps
    #
    # @param source [String] The source map (expecting a map of `1` and `0` only)
    # @param destination [String] The destination map (expecting a map of `1` and `0` only)
    # @return [String] A map with the changes between both maps:
    #   _ - Identical
    #   1 - Create (present on source only)
    #   0 - Destroy (present on destination only)
    def diff(source, destination)
      raise InvalidLength if source.size != destination.size

      new_result = "_" * source.size
      source.chars.each_with_index do |char, index|
        new_result[index] = char if destination[index] != char
      end

      new_result
    end

    # Extract ranges
    #
    # Returns all the ranges with their statuses.
    # The `_` is considered as empty and won't be returned as a range.
    # @param map [String] A map String
    # @param from [Date] The day that the map starts
    # @return [Array<Hash>] Returns an Array of Hashes with all the ranges
    def extract_ranges(map, from)
      ranges = []
      previous_char = nil
      range = nil
      map_length = map.length
      map.chars.each_with_index do |char, index|
        if char != previous_char && char != "_" # finished
          ranges << range if range

          range = {
            start_at: from.advance(days: index),
            end_at: from.advance(days: index + 1)
          }.merge(status: char)
        elsif char != "_" # continuing
          range[:end_at] = from.advance(days: index + 1)
        end

        if index == map_length - 1
          ranges << range if range
        end

        previous_char = char
      end

      ranges
    end
  end

  private

  def bookings_for_map(bookings, from, to)
    if bookings.is_a?(ActiveRecord::Relation)
      bookings.where("end_at > ? AND start_at <= ?", from.end_of_day, to)
        .order(:start_at)
    else
      bookings.find_all do |booking|
        booking.end_at > from.end_of_day && booking.start_at <= to
      end.sort_by { |booking| booking.start_at }
    end
  end

  def get_days_hash(start_at, end_at, default_value = nil)
    period = start_at...end_at # should not include end_at
    period.each_with_object({}) do |day, days|
      days[day] = default_value
    end
  end
end
