# frozen_string_literal: true

module Id3Taginator
  module Frames
    module Text
      class AlbumFrame < Id3v2Frame
        include HasId

        frame_info :TAL, :TALB, :TALB

        attr_accessor :album

        # builds the album frame
        #
        # @param album [String] the album name
        # @param options [Options::Options] options to use
        # @param id3_version [Integer] the id3 version to build the frame for
        #
        # @return [Id3v2Frame] the resulting id3v2 frame
        def self.build_frame(album, options = nil, id3_version: 3)
          supported?('TALB', id3_version, options)

          argument_not_nil(album, 'album')

          frame = new(frame_id(id3_version, options), 0, build_id3_flags(id3_version), '')
          frame.album = album
          frame
        end

        def process_content(content)
          @album = decode_using_encoding_byte(content)
        end

        def content_to_bytes
          encode_and_add_encoding_byte(@album)
        end
      end
    end
  end
end
