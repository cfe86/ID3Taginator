# frozen_string_literal: true

module Id3Taginator
  module Frames
    module Text
      class ComposerFrame < Id3v2Frame
        include HasId

        frame_info :TCM, :TCOM, :TCOM

        attr_accessor :composers

        # builds the composer frame
        #
        # @param composers [Array<String>, String] the composer(s)
        # @param options [Options::Options] options to use
        # @param id3_version [Integer] the id3 version to build the frame for
        #
        # @return [Id3v2Frame] the resulting id3v2 frame
        def self.build_frame(composers, options = nil, id3_version: 3)
          supported?('TCOM', id3_version, options)

          argument_not_empty(composers, 'composers')

          frame = new(frame_id(id3_version, options), 0, build_id3_flags(id3_version), '')
          frame.composers = composers.is_a?(Array) ? composers : [composers]
          frame
        end

        def process_content(content)
          content = decode_using_encoding_byte(content)
          @composers = content.split('/').map(&:strip)
        end

        def content_to_bytes
          content = @composers.join('/')
          encode_and_add_encoding_byte(content)
        end
      end
    end
  end
end
