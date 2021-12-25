# frozen_string_literal: true

module Id3Taginator
  module Frames
    module Text
      class TitleFrame < Id3v2Frame
        include HasId

        frame_info :TT2, :TIT2, :TIT2

        attr_accessor :title

        # builds the title frame
        #
        # @param title [String] the title
        # @param options [Options::Options] options to use
        # @param id3_version [Integer] the id3 version to build the frame for
        #
        # @return [Id3v2Frame] the resulting id3v2 frame
        def self.build_frame(title, options = nil, id3_version: 3)
          supported?('TIT2', id3_version, options)

          argument_not_nil(title, 'title')

          frame = new(frame_id(id3_version, options), 0, build_id3_flags(id3_version), '')
          frame.title = title
          frame
        end

        def process_content(content)
          @title = decode_using_encoding_byte(content)
        end

        def content_to_bytes
          encode_and_add_encoding_byte(@title)
        end
      end
    end
  end
end
