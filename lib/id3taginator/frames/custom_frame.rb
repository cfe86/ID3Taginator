# frozen_string_literal: true

module Id3Taginator
  module Frames
    class CustomFrame < Id3v2Frame

      attr_accessor :content

      # builds a custom frame
      #
      # @param content [String] the content
      # @param options [Options::Options] options to use
      # @param id3_version [Integer] the id3 version to build the frame for
      #
      # @return [Id3v2Frame] the resulting id3v2 frame
      def self.build_frame(content, _options = nil, id3_version: 3)
        argument_not_nil(content, 'content')

        frame = new(frame_id, 0, build_id3_flags(id3_version), '')
        frame.content = content
        frame
      end

      # takes the content as it is, no encoding or other modifications are performed
      #
      # @param content [String] the content
      def process_content(content)
        @content = content
      end

      # returns the content as it is, no encoding or other modifications are performed
      #
      # @return [String] the content
      def content_to_bytes
        @content
      end
    end
  end
end
