# frozen_string_literal: true

module Id3Taginator
  module Frames
    module Text
      class WritersFrame < Id3v2Frame
        include HasId

        frame_info :TXT, :TEXT, :TEXT

        attr_accessor :writers

        # builds the writers frame
        #
        # @param encoded_by [Array<String>, String] the writer(s)
        # @param options [Options::Options] options to use
        # @param id3_version [Integer] the id3 version to build the frame for
        #
        # @return [Id3v2Frame] the resulting id3v2 frame
        def self.build_frame(writers, options = nil, id3_version: 3)
          supported?('TEXT', id3_version, options)

          argument_not_empty(writers, 'writers')

          frame = new(frame_id(id3_version, options), 0, build_id3_flags(id3_version), '')
          frame.writers = writers.is_a?(Array) ? writers : [writers]
          frame
        end

        def process_content(content)
          writers_str = decode_using_encoding_byte(content)
          @writers = writers_str.split('/').map(&:strip)
        end

        def content_to_bytes
          @writers ||= ['[unset]']
          content = @writers.join('/')
          encode_and_add_encoding_byte(content)
        end
      end
    end
  end
end
