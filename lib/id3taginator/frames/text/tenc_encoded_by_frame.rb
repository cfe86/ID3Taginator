# frozen_string_literal: true

module Id3Taginator
  module Frames
    module Text
      class EncodedByFrame < Id3v2Frame
        include HasId

        frame_info :TEN, :TENC, :TENC

        attr_accessor :encoded_by

        # builds the encoded by frame
        #
        # @param encoded_by [String] the encoded by
        # @param options [Options::Options] options to use
        # @param id3_version [Integer] the id3 version to build the frame for
        #
        # @return [Id3v2Frame] the resulting id3v2 frame
        def self.build_frame(encoded_by, options = nil, id3_version: 3)
          supported?('TENC', id3_version, options)

          argument_not_nil(encoded_by, 'encoded_by')

          frame = new(frame_id(id3_version, options), 0, build_id3_flags(id3_version), '')
          frame.encoded_by = encoded_by
          frame
        end

        def process_content(content)
          @encoded_by = decode_using_encoding_byte(content)
        end

        def content_to_bytes
          encode_and_add_encoding_byte(@encoded_by)
        end
      end
    end
  end
end
