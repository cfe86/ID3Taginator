# frozen_string_literal: true

module Id3Taginator
  module Frames
    module Text
      class OriginalArtistsFrame < Id3v2Frame
        include HasId

        frame_info :TOA, :TOPE, :TOPE

        attr_accessor :original_artists

        # builds the original artists frame
        #
        # @param original_artists [Array<String>, String] the original artist(s)
        # @param options [Options::Options] options to use
        # @param id3_version [Integer] the id3 version to build the frame for
        #
        # @return [Id3v2Frame] the resulting id3v2 frame
        def self.build_frame(original_artists, options = nil, id3_version: 3)
          supported?('TOPE', id3_version, options)

          argument_not_empty(original_artists, 'original_artists')

          frame = new(frame_id(id3_version, options), 0, build_id3_flags(id3_version), '')
          frame.original_artists = original_artists.is_a?(Array) ? original_artists : [original_artists]
          frame
        end

        def process_content(content)
          artists_str = decode_using_encoding_byte(content)
          @original_artists = artists_str.split('/').map(&:strip)
        end

        def content_to_bytes
          @original_artists ||= ['[unset]']
          content = @original_artists.join('/')
          encode_and_add_encoding_byte(content)
        end
      end
    end
  end
end
