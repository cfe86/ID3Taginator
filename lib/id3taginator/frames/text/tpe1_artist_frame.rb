# frozen_string_literal: true

module Id3Taginator
  module Frames
    module Text
      class ArtistsFrame < Id3v2Frame
        include HasId

        frame_info :TP1, :TPE1, :TPE1

        attr_accessor :artists

        # builds the artists frame
        #
        # @param artists [Array<String>, String] the artist(s)
        # @param options [Options::Options] options to use
        # @param id3_version [Integer] the id3 version to build the frame for
        #
        # @return [Id3v2Frame] the resulting id3v2 frame
        def self.build_frame(artists, options = nil, id3_version: 3)
          supported?('TPE1', id3_version, options)

          argument_not_empty(artists, 'artists')

          frame = new(frame_id(id3_version, options), 0, build_id3_flags(id3_version), '')
          frame.artists = artists.is_a?(Array) ? artists : [artists]
          frame
        end

        def process_content(content)
          artists_str = decode_using_encoding_byte(content)
          @artists = artists_str.split('/').map(&:strip)
        end

        def content_to_bytes
          @artists ||= ['[unset]']
          content = @artists.join('/')
          encode_and_add_encoding_byte(content)
        end
      end
    end
  end
end
