# frozen_string_literal: true

module Id3Taginator
  module Frames
    module Text
      class PublisherFrame < Id3v2Frame
        include HasId

        frame_info :TPB, :TPUB, :TPUB

        attr_accessor :publisher

        # builds the publisher frame
        #
        # @param publisher [String] the publisher
        # @param options [Options::Options] options to use
        # @param id3_version [Integer] the id3 version to build the frame for
        #
        # @return [Id3v2Frame] the resulting id3v2 frame
        def self.build_frame(publisher, options = nil, id3_version: 3)
          supported?('TPUB', id3_version, options)

          argument_not_empty(publisher, 'publisher')

          frame = new(frame_id(id3_version, options), 0, build_id3_flags(id3_version), '')
          frame.publisher = publisher
          frame
        end

        def process_content(content)
          @publisher = decode_using_encoding_byte(content)
        end

        def content_to_bytes
          encode_and_add_encoding_byte(@publisher)
        end
      end
    end
  end
end
