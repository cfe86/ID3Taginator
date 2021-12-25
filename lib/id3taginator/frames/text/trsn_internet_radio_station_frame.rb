# frozen_string_literal: true

module Id3Taginator
  module Frames
    module Text
      class InternetRadioStationFrame < Id3v2Frame
        include HasId

        frame_info nil, :TRSN, :TRSN

        attr_accessor :station_name

        # builds the radio station frame
        #
        # @param station_name [String] the recording date(s)
        # @param options [Options::Options] options to use
        # @param id3_version [Integer] the id3 version to build the frame for
        #
        # @return [Id3v2Frame] the resulting id3v2 frame
        def self.build_frame(station_name, options = nil, id3_version: 3)
          supported?('TRSN', id3_version, options)

          argument_not_nil(station_name, 'station_name')

          frame = new(frame_id(id3_version, options), 0, build_id3_flags(id3_version), '')
          frame.station_name = station_name
          frame
        end

        def process_content(content)
          @station_name = decode_using_encoding_byte(content)
        end

        def content_to_bytes
          encode_and_add_encoding_byte(@station_name)
        end
      end
    end
  end
end
