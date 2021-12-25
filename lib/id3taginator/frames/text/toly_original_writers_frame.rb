# frozen_string_literal: true

module Id3Taginator
  module Frames
    module Text
      class OriginalWritersFrame < Id3v2Frame
        include HasId

        frame_info :TOL, :TOLY, :TOLY

        attr_accessor :original_writers

        # builds the original writers frame
        #
        # @param original_writers [Array<String>, String] the original writer(s)
        # @param options [Options::Options] options to use
        # @param id3_version [Integer] the id3 version to build the frame for
        #
        # @return [Id3v2Frame] the resulting id3v2 frame
        def self.build_frame(original_writers, options = nil, id3_version: 3)
          supported?('TOLY', id3_version, options)

          argument_not_empty(original_writers, 'original_writers')

          frame = new(frame_id(id3_version, options), 0, build_id3_flags(id3_version), '')
          frame.original_writers = original_writers.is_a?(Array) ? original_writers : [original_writers]
          frame
        end

        def process_content(content)
          writers_str = decode_using_encoding_byte(content)
          @original_writers = writers_str.split('/').map(&:strip)
        end

        def content_to_bytes
          @original_writers ||= ['[unset]']
          content = @original_writers.join('/')
          encode_and_add_encoding_byte(content)
        end
      end
    end
  end
end
