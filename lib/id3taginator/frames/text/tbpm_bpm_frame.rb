# frozen_string_literal: true

module Id3Taginator
  module Frames
    module Text
      class BPMFrame < Id3v2Frame
        include HasId

        frame_info :TBP, :TBPM, :TBPM

        attr_accessor :bpm

        # builds the bpm frame
        #
        # @param album [String, Integer] the bpm
        # @param options [Options::Options] options to use
        # @param id3_version [Integer] the id3 version to build the frame for
        #
        # @return [Id3v2Frame] the resulting id3v2 frame
        def self.build_frame(bpm, options = nil, id3_version: 3)
          supported?('TBPM', id3_version, options)

          argument_not_nil(bpm, 'bpm')

          frame = new(frame_id(id3_version, options), 0, build_id3_flags(id3_version), '')
          frame.bpm = bpm.to_s
          frame
        end

        def process_content(content)
          @bpm = decode_using_encoding_byte(content)
        end

        def content_to_bytes
          encode_and_add_encoding_byte(@bpm)
        end
      end
    end
  end
end
