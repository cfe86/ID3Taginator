# frozen_string_literal: true

module Id3Taginator
  module Frames
    module Text
      class RecordingDatesFrame < Id3v2Frame
        include HasId

        frame_info :TRD, :TRDA, :TRDA

        attr_accessor :recording_dates

        # builds the recording dates frame
        #
        # @param recording_dates [Array<String>, String] the recording date(s)
        # @param options [Options::Options] options to use
        # @param id3_version [Integer] the id3 version to build the frame for
        #
        # @return [Id3v2Frame] the resulting id3v2 frame
        def self.build_frame(recording_dates, options = nil, id3_version: 3)
          supported?('TRDA', id3_version, options)

          argument_not_empty(recording_dates, 'recording_dates')

          frame = new(frame_id(id3_version, options), 0, build_id3_flags(id3_version), '')
          frame.recording_dates = recording_dates.is_a?(Array) ? recording_dates : [recording_dates]
          frame
        end

        def process_content(content)
          content = decode_using_encoding_byte(content)
          @recording_dates = content.split(',').map(&:strip)
        end

        def content_to_bytes
          content = @recording_dates.join(', ')
          encode_and_add_encoding_byte(content)
        end
      end
    end
  end
end
