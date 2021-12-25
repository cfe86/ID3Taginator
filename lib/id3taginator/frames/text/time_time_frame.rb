# frozen_string_literal: true

module Id3Taginator
  module Frames
    module Text
      class TimeFrame < Id3v2Frame
        include HasId

        frame_info :TIM, :TIME, :TIME

        attr_accessor :hours, :minutes

        # builds the time frame
        #
        # @param hours [String, Integer] the hours
        # @param minutes [String, Integer] the minutes
        # @param options [Options::Options] options to use
        # @param id3_version [Integer] the id3 version to build the frame for
        #
        # @return [Id3v2Frame] the resulting id3v2 frame
        def self.build_frame(hours, minutes, options = nil, id3_version: 3)
          supported?('TIME', id3_version, options)

          argument_not_nil(hours, 'hours')
          argument_not_nil(minutes, 'minutes')
          hours = pad_right(hours.to_s, 2)
          minutes = pad_right(minutes.to_s, 2)
          argument_less_than_chars(hours, 'hours', 2)
          argument_less_than_chars(minutes, 'minutes', 2)

          hours = pad_right(hours, 2, '0')
          minutes = pad_right(minutes, 2, '0')

          frame = new(frame_id(id3_version, options), 0, build_id3_flags(id3_version), '')
          frame.hours = hours
          frame.minutes = minutes
          frame
        end

        def process_content(content)
          content = decode_using_encoding_byte(content)
          if content.length != 4
            @hours = '0'
            @minutes = '0'
          else
            @hours = content[0..1]
            @minutes = content[2..3]
          end
        end

        def content_to_bytes
          @hours ||= '0'
          @minutes ||= '0'
          content = "#{pad_right(@hours.to_s, 2, '0')}#{pad_right(@minutes.to_s, 2, '0')}"
          encode_and_add_encoding_byte(content)
        end
      end
    end
  end
end
