# frozen_string_literal: true

module Id3Taginator
  module Frames
    module Text
      class ModifiedByFrame < Id3v2Frame
        include HasId

        frame_info :TP4, :TPE4, :TPE4

        attr_accessor :modified_by

        # builds the modified by frame
        #
        # @param modified_by [String] the modified by
        # @param options [Options::Options] options to use
        # @param id3_version [Integer] the id3 version to build the frame for
        #
        # @return [Id3v2Frame] the resulting id3v2 frame
        def self.build_frame(modified_by, options = nil, id3_version: 3)
          supported?('TPE4', id3_version, options)

          argument_not_nil(modified_by, 'modified_by')

          frame = new(frame_id(id3_version, options), 0, build_id3_flags(id3_version), '')
          frame.modified_by = modified_by
          frame
        end

        def process_content(content)
          @modified_by = decode_using_encoding_byte(content)
        end

        def content_to_bytes
          encode_and_add_encoding_byte(@modified_by)
        end
      end
    end
  end
end
