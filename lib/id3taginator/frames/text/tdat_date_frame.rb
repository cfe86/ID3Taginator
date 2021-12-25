# frozen_string_literal: true

module Id3Taginator
  module Frames
    module Text
      class DateFrame < Id3v2Frame
        include HasId

        frame_info :TDA, :TDAT, :TDAT

        attr_accessor :day, :month

        # builds the date frame
        #
        # @param day [String, Integer] the day
        # @param month [String, Integer] the month
        # @param options [Options::Options] options to use
        # @param id3_version [Integer] the id3 version to build the frame for
        #
        # @return [Id3v2Frame] the resulting id3v2 frame
        def self.build_frame(day, month, options = nil, id3_version: 3)
          supported?('TDAT', id3_version, options)

          argument_not_nil(month, 'month')
          argument_not_nil(day, 'day')
          month = pad_right(month.to_s, 2, '0')
          day = pad_right(day.to_s, 2, '0')
          argument_more_than_chars(day, 'day', 2)
          argument_more_than_chars(month, 'month', 2)

          month = pad_right(month, 2, '0')
          day = pad_right(day, 2, '0')

          frame = new(frame_id(id3_version, options), 0, build_id3_flags(id3_version), '')
          frame.day = day
          frame.month = month
          frame
        end

        def process_content(content)
          content = decode_using_encoding_byte(content)
          if content.length != 4
            @day = '1'
            @month = '1'
          else
            @day = content[0..1]
            @month = content[2..3]
          end
        end

        def content_to_bytes
          @day ||= '1'
          @month ||= '1'
          content = "#{pad_right(@day.to_s, 2, '0')}#{pad_right(@month.to_s, 2, '0')}"
          encode_and_add_encoding_byte(content)
        end
      end
    end
  end
end
