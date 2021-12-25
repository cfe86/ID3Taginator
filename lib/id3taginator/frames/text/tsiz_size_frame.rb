# frozen_string_literal: true

module Id3Taginator
  module Frames
    module Text
      class SizeFrame < Id3v2Frame
        include HasId

        frame_info :TSI, :TSIZ, nil

        attr_accessor :size

        # builds the size frame
        #
        # @param size [String, Integer] the size in bytes
        # @param options [Options::Options] options to use
        # @param id3_version [Integer] the id3 version to build the frame for
        #
        # @return [Id3v2Frame] the resulting id3v2 frame
        def self.build_frame(size, options = nil, id3_version: 3)
          supported?('TSIZ', id3_version, options)

          argument_not_nil(size, 'size')
          size = size.to_s

          frame = new(frame_id(id3_version, options), 0, build_id3_flags(id3_version), '')
          frame.size = size
          frame
        end

        def process_content(content)
          @size = decode_using_encoding_byte(content)
        end

        def content_to_bytes
          encode_and_add_encoding_byte(@size)
        end
      end
    end
  end
end
