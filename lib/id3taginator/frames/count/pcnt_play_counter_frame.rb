# frozen_string_literal: true

module Id3Taginator
  module Frames
    module Count
      class PlayCounterFrame < Id3v2Frame
        include HasId

        frame_info :CNT, :PCNT, :PCNT

        attr_accessor :counter

        # builds the play counter frame
        #
        # @param counter [Integer] the counter, default a 32 bit integer, but can be higher too
        # @param options [Options::Options] options to use
        # @param id3_version [Integer] the id3 version to build the frame for
        #
        # @return [Id3v2Frame] the resulting id3v2 frame
        def self.build_frame(counter, options = nil, id3_version: 3)
          supported?('PCNT', id3_version, options)

          argument_not_nil(counter, 'counter')

          frame = new(frame_id(id3_version, options), 0, build_id3_flags(id3_version), '')
          frame.counter = counter
          frame
        end

        def process_content(content)
          @counter = Util::MathUtil.to_number(content.bytes)
        end

        def content_to_bytes
          Util::MathUtil.from_number(@counter, 8, '0')
        end
      end
    end
  end
end
