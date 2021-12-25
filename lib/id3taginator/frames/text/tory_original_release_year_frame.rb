# frozen_string_literal: true

module Id3Taginator
  module Frames
    module Text
      class OriginalReleaseYearFrame < Id3v2Frame
        include HasId

        frame_info :TOR, :TORY, :TORY

        attr_accessor :original_release_year

        # builds the original release year frame
        #
        # @param original_release_year [String, Integer] the original release year as a 4 character string, e.g. 2020
        # @param options [Options::Options] options to use
        # @param id3_version [Integer] the id3 version to build the frame for
        #
        # @return [Id3v2Frame] the resulting id3v2 frame
        def self.build_frame(original_release_year, options = nil, id3_version: 3)
          supported?('TORY', id3_version, options)

          argument_not_nil(original_release_year, 'original_release_year')
          original_release_year = original_release_year.to_s
          argument_exactly_chars(original_release_year, 'original_release_year', 4)

          frame = new(frame_id(id3_version, options), 0, build_id3_flags(id3_version), '')
          frame.original_release_year = original_release_year
          frame
        end

        def process_content(content)
          @original_release_year = decode_using_encoding_byte(content)
        end

        def content_to_bytes
          encode_and_add_encoding_byte(@original_release_year)
        end
      end
    end
  end
end
