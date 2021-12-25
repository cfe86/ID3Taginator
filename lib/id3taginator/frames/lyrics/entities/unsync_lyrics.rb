# frozen_string_literal: true

module Id3Taginator
  module Frames
    module Lyrics
      module Entities
        class UnsyncLyrics
          include Extensions::Comparable

          attr_accessor :language, :descriptor, :lyrics

          # constructor
          #
          # @param language [String] the lyrics language as 3 character language
          # @param descriptor [String] the description
          # @param lyrics [String] the lyrics text
          def initialize(language, descriptor, lyrics)
            @language = language
            @descriptor = descriptor
            @lyrics = lyrics
          end
        end
      end
    end
  end
end
