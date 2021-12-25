# frozen_string_literal: true

module Id3Taginator
  module Frames
    module Text
      class TrackNumberFrame < Id3v2Frame
        include HasId

        frame_info :TRK, :TRCK, :TRCK

        attr_accessor :track_number, :total

        # builds the track number frame
        #
        # @param track_number [String, Integer] the track number
        # @param total [String, Integer, nil] the total number of tracks
        # @param options [Options::Options] options to use
        # @param id3_version [Integer] the id3 version to build the frame for
        #
        # @return [Id3v2Frame] the resulting id3v2 frame
        def self.build_frame(track_number, total, options = nil, id3_version: 3)
          supported?('TRCK', id3_version, options)

          argument_not_empty(track_number, 'track_number')

          track_number = track_number.to_s
          total = total.to_s unless total.nil?

          frame = new(frame_id(id3_version, options), 0, build_id3_flags(id3_version), '')
          frame.track_number = track_number
          frame.total = total
          frame
        end

        def process_content(content)
          content = decode_using_encoding_byte(content)
          tmp = content.split('/')
          @track_number = tmp[0]
          @total = tmp[1]
        end

        def content_to_bytes
          return encode_and_add_encoding_byte(@track_number) if @total.nil?

          encode_and_add_encoding_byte("#{@track_number}/#{@total}")
        end
      end
    end
  end
end
