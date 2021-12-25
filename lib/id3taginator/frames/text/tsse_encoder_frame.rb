# frozen_string_literal: true

module Id3Taginator
  module Frames
    module Text
      class EncoderFrame < Id3v2Frame
        include HasId

        frame_info :TSS, :TSSE, :TSSE

        attr_accessor :encoder

        # builds the encoder frame
        #
        # @param encoder [String] the ISRC number, 12 characters long
        # @param options [Options::Options] options to use
        # @param id3_version [Integer] the id3 version to build the frame for
        #
        # @return [Id3v2Frame] the resulting id3v2 frame
        def self.build_frame(encoder, options = nil, id3_version: 3)
          supported?('TSSE', id3_version, options)

          argument_not_nil(encoder, 'encoder')

          frame = new(frame_id(id3_version, options), 0, build_id3_flags(id3_version), '')
          frame.encoder = encoder
          frame
        end

        def process_content(content)
          @encoder = decode_using_encoding_byte(content)
        end

        def content_to_bytes
          encode_and_add_encoding_byte(@encoder)
        end
      end
    end
  end
end
