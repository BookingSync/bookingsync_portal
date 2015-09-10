class BookingsyncPortal::BookingMap
  class InvalidLength < StandardError
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
end
