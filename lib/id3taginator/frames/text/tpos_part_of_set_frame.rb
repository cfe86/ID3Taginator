# frozen_string_literal: true

module Id3Taginator
  module Frames
    module Text
      class PartOfSetFrame < Id3v2Frame
        include HasId

        frame_info :TPA, :TPOS, :TPOS

        attr_accessor :part, :total

        # builds the part of set frame
        #
        # @param part [String, Integer] part of the set
        # @param total [String, Integer, nil] total number of parts
        # @param options [Options::Options] options to use
        # @param id3_version [Integer] the id3 version to build the frame for
        #
        # @return [Id3v2Frame] the resulting id3v2 frame
        def self.build_frame(part, total, options = nil, id3_version: 3)
          supported?('TPOS', id3_version, options)

          argument_not_nil(part, 'part')

          part = part.to_s
          total = total.to_s unless total.nil?

          frame = new(frame_id(id3_version, options), 0, build_id3_flags(id3_version), '')
          frame.part = part
          frame.total = total
          frame
        end

        def process_content(content)
          content = decode_using_encoding_byte(content)
          tmp = content.split('/')
          @part = tmp[0]
          @total = tmp[1]
        end

        def content_to_bytes
          return encode_and_add_encoding_byte(@part) if @total.nil?

          encode_and_add_encoding_byte("#{@part}/#{@total}")
        end
      end
    end
  end
end
