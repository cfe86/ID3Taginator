# frozen_string_literal: true

module Id3Taginator
  module Frames
    module Grouping
      class GroupingFrame < Id3v2Frame
        include HasId

        frame_info nil, :GRP1, :GRP1

        attr_accessor :grouping

        # builds the group identification frame
        #
        # @param grouping [String] the Grouping Information
        # @param options [Options::Options] options to use
        # @param id3_version [Integer] the id3 version to build the frame for
        #
        # @return [Id3v2Frame] the resulting id3v2 frame
        def self.build_frame(grouping, options = nil, id3_version: 3)
          supported?('GRP1', id3_version, options)

          argument_not_nil(grouping, 'grouping')

          frame = new(frame_id(id3_version, options), 0, build_id3_flags(id3_version), '')
          frame.grouping = grouping.to_s
          frame
        end

        def process_content(content)
          @grouping = decode_using_encoding_byte(content)
        end

        def content_to_bytes
          encode_and_add_encoding_byte(@grouping)
        end
      end
    end
  end
end
