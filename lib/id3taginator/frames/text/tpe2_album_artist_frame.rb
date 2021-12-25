# frozen_string_literal: true

module Id3Taginator
  module Frames
    module Text
      class AlbumArtistFrame < Id3v2Frame
        include HasId

        frame_info :TP2, :TPE2, :TPE2

        attr_accessor :album_artist

        # builds the album artist frame
        #
        # @param album_artist [String] the album artist
        # @param options [Options::Options] options to use
        # @param id3_version [Integer] the id3 version to build the frame for
        #
        # @return [Id3v2Frame] the resulting id3v2 frame
        def self.build_frame(album_artist, options = nil, id3_version: 3)
          supported?('TPE2', id3_version, options)

          argument_not_nil(album_artist, 'album_artist')

          frame = new(frame_id(id3_version, options), 0, build_id3_flags(id3_version), '')
          frame.album_artist = album_artist
          frame
        end

        def process_content(content)
          @album_artist = decode_using_encoding_byte(content)
        end

        def content_to_bytes
          encode_and_add_encoding_byte(@album_artist)
        end
      end
    end
  end
end
