# frozen_string_literal: true

module Id3Taginator
  module Frames
    module Text
      class PlaylistDelayFrame < Id3v2Frame
        include HasId

        frame_info :TDY, :TDLY, :TDLY

        attr_accessor :delay

        # builds the playlist delay frame
        #
        # @param delay [String, Integer] the playlist delay in ms
        # @param options [Options::Options] options to use
        # @param id3_version [Integer] the id3 version to build the frame for
        #
        # @return [Id3v2Frame] the resulting id3v2 frame
        def self.build_frame(delay, options = nil, id3_version: 3)
          supported?('TDLY', id3_version, options)

          argument_not_nil(delay, 'delay')

          frame = new(frame_id(id3_version, options), 0, build_id3_flags(id3_version), '')
          frame.delay = delay.to_s
          frame
        end

        def process_content(content)
          @delay = decode_using_encoding_byte(content)
        end

        def content_to_bytes
          encode_and_add_encoding_byte(@delay)
        end
      end
    end
  end
end
