# frozen_string_literal: true

module Id3Taginator
  module Frames
    module Text
      class PerformerSortOrderFrame < Id3v2Frame
        include HasId

        frame_info nil, nil, :TSOP

        attr_accessor :performer

        # builds the performer sort order frame
        #
        # @param performer [String] the performer to use for sorting
        # @param options [Options::Options] options to use
        # @param id3_version [Integer] the id3 version to build the frame for
        #
        # @return [Id3v2Frame] the resulting id3v2 frame
        def self.build_frame(performer, options = nil, id3_version: 3)
          supported?('TSOP', id3_version, options)

          argument_not_nil(performer, 'performer')

          frame = new(frame_id(id3_version, options), 0, build_id3_flags(id3_version), '')
          frame.performer = performer
          frame
        end

        def process_content(content)
          @performer = decode_using_encoding_byte(content)
        end

        def content_to_bytes
          encode_and_add_encoding_byte(@performer)
        end
      end
    end
  end
end
