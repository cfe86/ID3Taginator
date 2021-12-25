# frozen_string_literal: true

module Id3Taginator
  module Frames
    module Text
      class YearFrame < Id3v2Frame
        include HasId

        frame_info :TYE, :TYER, :TYER

        attr_accessor :year

        # builds the year frame
        #
        # @param year [String, Integer] the 4 character year, e.g. 2020
        # @param options [Options::Options] options to use
        # @param id3_version [Integer] the id3 version to build the frame for
        #
        # @return [Id3v2Frame] the resulting id3v2 frame
        def self.build_frame(year, options = nil, id3_version: 3)
          supported?('TYER', id3_version, options)

          argument_not_nil(year, 'year')
          year = year.to_s
          argument_exactly_chars(year, 'year', 4)

          frame = new(frame_id(id3_version, options), 0, build_id3_flags(id3_version), '')
          frame.year = year
          frame
        end

        def process_content(content)
          @year = decode_using_encoding_byte(content)
        end

        def content_to_bytes
          encode_and_add_encoding_byte(@year)
        end
      end
    end
  end
end
