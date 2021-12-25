# frozen_string_literal: true

module Id3Taginator
  module Frames
    module Text
      class OriginalAlbumFrame < Id3v2Frame
        include HasId

        frame_info :TOT, :TOAL, :TOAL

        attr_accessor :original_album

        # builds the original album frame
        #
        # @param original_album [String] the original album
        # @param options [Options::Options] options to use
        # @param id3_version [Integer] the id3 version to build the frame for
        #
        # @return [Id3v2Frame] the resulting id3v2 frame
        def self.build_frame(original_album, options = nil, id3_version: 3)
          supported?('TOAL', id3_version, options)

          argument_not_nil(original_album, 'original_album')

          frame = new(frame_id(id3_version, options), 0, build_id3_flags(id3_version), '')
          frame.original_album = original_album
          frame
        end

        def process_content(content)
          @original_album = decode_using_encoding_byte(content)
        end

        def content_to_bytes
          encode_and_add_encoding_byte(@original_album)
        end
      end
    end
  end
end
