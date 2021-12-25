# frozen_string_literal: true

module Id3Taginator
  module Frames
    module Text
      class ContentGroupDescriptionFrame < Id3v2Frame
        include HasId

        frame_info :TT1, :TIT1, :TIT1

        attr_accessor :content_description

        # builds the content group description frame
        #
        # @param content_description [String] the content group description
        # @param options [Options::Options] options to use
        # @param id3_version [Integer] the id3 version to build the frame for
        #
        # @return [Id3v2Frame] the resulting id3v2 frame
        def self.build_frame(content_description, options = nil, id3_version: 3)
          supported?('TIT1', id3_version, options)

          argument_not_nil(content_description, 'content_description')

          frame = new(frame_id(id3_version, options), 0, build_id3_flags(id3_version), '')
          frame.content_description = content_description
          frame
        end

        def process_content(content)
          @content_description = decode_using_encoding_byte(content)
        end

        def content_to_bytes
          encode_and_add_encoding_byte(@content_description)
        end
      end
    end
  end
end
