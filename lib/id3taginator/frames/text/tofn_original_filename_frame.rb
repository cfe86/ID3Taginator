# frozen_string_literal: true

module Id3Taginator
  module Frames
    module Text
      class OriginalFilenameFrame < Id3v2Frame
        include HasId

        frame_info :TOF, :TOFN, :TOFN

        attr_accessor :original_filename

        # builds the original filename frame
        #
        # @param original_filename [String] the original filename
        # @param options [Options::Options] options to use
        # @param id3_version [Integer] the id3 version to build the frame for
        #
        # @return [Id3v2Frame] the resulting id3v2 frame
        def self.build_frame(original_filename, options = nil, id3_version: 3)
          supported?('TOFN', id3_version, options)

          argument_not_nil(original_filename, 'original_filename')

          frame = new(frame_id(id3_version, options), 0, build_id3_flags(id3_version), '')
          frame.original_filename = original_filename
          frame
        end

        def process_content(content)
          @original_filename = decode_using_encoding_byte(content)
        end

        def content_to_bytes
          encode_and_add_encoding_byte(@original_filename)
        end
      end
    end
  end
end
