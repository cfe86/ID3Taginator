# frozen_string_literal: true

module Id3Taginator
  module Frames
    module Text
      class ISRCFrame < Id3v2Frame
        include HasId

        frame_info :TRC, :TSRC, :TSRC

        attr_accessor :isrc

        # builds the ISRC frame
        #
        # @param isrc [String] the ISRC number, 12 characters long
        # @param options [Options::Options] options to use
        # @param id3_version [Integer] the id3 version to build the frame for
        #
        # @return [Id3v2Frame] the resulting id3v2 frame
        def self.build_frame(isrc, options = nil, id3_version: 3)
          supported?('TSRC', id3_version, options)

          argument_exactly_chars(isrc, 'isrc', 12)

          frame = new(frame_id(id3_version, options), 0, build_id3_flags(id3_version), '')
          frame.isrc = isrc
          frame
        end

        def process_content(content)
          @isrc = decode_using_encoding_byte(content)
        end

        def content_to_bytes
          encode_and_add_encoding_byte(@isrc)
        end
      end
    end
  end
end
