# frozen_string_literal: true

module Id3Taginator
  module Frames
    module Text
      class SubtitleFrame < Id3v2Frame
        include HasId

        frame_info :TT3, :TIT3, :TIT3

        attr_accessor :subtitle

        # builds the subtitle frame
        #
        # @param subtitle [String] the subtitle
        # @param options [Options::Options] options to use
        # @param id3_version [Integer] the id3 version to build the frame for
        #
        # @return [Id3v2Frame] the resulting id3v2 frame
        def self.build_frame(subtitle, options = nil, id3_version: 3)
          supported?('TIT3', id3_version, options)

          argument_not_nil(subtitle, 'subtitle')

          frame = new(frame_id(id3_version, options), 0, build_id3_flags(id3_version), '')
          frame.subtitle = subtitle
          frame
        end

        def process_content(content)
          @subtitle = decode_using_encoding_byte(content)
        end

        def content_to_bytes
          encode_and_add_encoding_byte(@subtitle)
        end
      end
    end
  end
end
