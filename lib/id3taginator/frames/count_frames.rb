# frozen_string_literal: true

module Id3Taginator
  module Frames
    module CountFrames
      include Frames::Frameable

      # extracts the play count (PCNT/CNT)
      #
      # @return [Integer, nil] returns counter
      def play_counter
        find_frame(Count::PlayCounterFrame.frame_id(@major_version, @options))&.counter
      end

      # sets a counter (PCNT/CNT)
      #
      # @param counter [Integer] the counter to set
      def play_counter=(counter)
        set_frame_fields(Count::PlayCounterFrame, [:@counter], counter)
      end

      # removes the play counter frame
      def remove_play_counter
        @frames.delete_if { |f| f.frame_id == Count::PlayCounterFrame.frame_id(@major_version, @options) }
      end

      # extracts the popularity (POPM/POP)
      #
      # @return [Frames::Count::Entities::Popularimeter, nil] returns popularity
      def popularity
        frame = find_frame(Count::PopularityFrame.frame_id(@major_version, @options))
        return nil if frame.nil?

        Count::Entities::Popularimeter.new(frame.email, frame.rating, frame.counter)
      end

      # sets a counter (POPM/POP)
      #
      # @param popularity [Frames::Count::Entities::Popularimeter] the popularity to set
      def popularity=(popularity)
        set_frame_fields(Count::PopularityFrame, %i[@email @rating @counter],
                         popularity.email, popularity.rating, popularity.counter)
      end

      # removes the popularity frame
      def remove_popularity
        @frames.delete_if { |f| f.frame_id == Count::PopularityFrame.frame_id(@major_version, @options) }
      end
    end
  end
end
