# frozen_string_literal: true

module Id3Taginator
  module Frames
    module Text
      class InitialKeyFrame < Id3v2Frame
        include HasId

        frame_info :TKE, :TKEY, :TKEY

        attr_accessor :initial_key

        # builds the initial key frame
        #
        # @param initial_key [String] the initial key, can have up to 3 characters
        # @param options [Options::Options] options to use
        # @param id3_version [Integer] the id3 version to build the frame for
        #
        # @return [Id3v2Frame] the resulting id3v2 frame
        def self.build_frame(initial_key, options = nil, id3_version: 3)
          supported?('TKEY', id3_version, options)

          argument_less_than_chars(initial_key, 'initial_key', 3)

          frame = new(frame_id(id3_version, options), 0, build_id3_flags(id3_version), '')
          frame.initial_key = initial_key
          frame
        end

        def process_content(content)
          @initial_key = decode_using_encoding_byte(content)
        end

        def content_to_bytes
          encode_and_add_encoding_byte(@initial_key)
        end
      end
    end
  end
end
