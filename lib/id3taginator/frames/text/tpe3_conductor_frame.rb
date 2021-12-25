# frozen_string_literal: true

module Id3Taginator
  module Frames
    module Text
      class ConductorFrame < Id3v2Frame
        include HasId

        frame_info :TP3, :TPE3, :TPE3

        attr_accessor :conductor

        # builds the conductor frame
        #
        # @param conductor [String] the conductor
        # @param options [Options::Options] options to use
        # @param id3_version [Integer] the id3 version to build the frame for
        #
        # @return [Id3v2Frame] the resulting id3v2 frame
        def self.build_frame(conductor, options = nil, id3_version: 3)
          supported?('TPE3', id3_version, options)

          argument_not_nil(conductor, 'conductor')

          frame = new(frame_id(id3_version, options), 0, build_id3_flags(id3_version), '')
          frame.conductor = conductor
          frame
        end

        def process_content(content)
          @conductor = decode_using_encoding_byte(content)
        end

        def content_to_bytes
          encode_and_add_encoding_byte(@conductor)
        end
      end
    end
  end
end
