# frozen_string_literal: true

module Id3Taginator
  module Frames
    module Text
      class LengthFrame < Id3v2Frame
        include HasId

        frame_info :TLE, :TLEN, :TLEN

        attr_accessor :length

        # builds the length frame
        #
        # @param length [String, Integer] the length in ms
        # @param options [Options::Options] options to use
        # @param id3_version [Integer] the id3 version to build the frame for
        #
        # @return [Id3v2Frame] the resulting id3v2 frame
        def self.build_frame(length, options = nil, id3_version: 3)
          supported?('TLEN', id3_version, options)

          argument_not_nil(length, 'length')

          frame = new(frame_id(id3_version, options), 0, build_id3_flags(id3_version), '')
          frame.length = length.to_s
          frame
        end

        def process_content(content)
          @length = decode_using_encoding_byte(content)
        end

        def content_to_bytes
          encode_and_add_encoding_byte(@length)
        end
      end
    end
  end
end
