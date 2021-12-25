# frozen_string_literal: true

module Id3Taginator
  module Frames
    module Text
      module Entities
        class TrackNumber
          include Extensions::Comparable

          attr_accessor :track_number, :total

          # constructor
          #
          # @param track_number [String, Integer] the track number
          # @param total [String, Integer, nil] the total number of tracks
          def initialize(track_number, total)
            @track_number = track_number
            @total = total
          end
        end
      end
    end
  end
end
