# frozen_string_literal: true

module Id3Taginator
  module Frames
    module Text
      class MediaTypeFrame < Id3v2Frame
        include HasId

        frame_info :TMT, :TMED, :TMED

        attr_accessor :media_type

        # builds the media type frame
        #
        # @param media_type [String] the media type
        # @param options [Options::Options] options to use
        # @param id3_version [Integer] the id3 version to build the frame for
        #
        # @return [Id3v2Frame] the resulting id3v2 frame
        def self.build_frame(media_type, options = nil, id3_version: 3)
          supported?('TMED', id3_version, options)

          argument_not_nil(media_type, 'media_type')

          frame = new(frame_id(id3_version, options), 0, build_id3_flags(id3_version), '')
          frame.media_type = media_type
          frame
        end

        def process_content(content)
          @media_type = decode_using_encoding_byte(content)
        end

        def content_to_bytes
          encode_and_add_encoding_byte(@media_type)
        end
      end
    end
  end
end
