# frozen_string_literal: true

module Id3Taginator
  module Frames
    module Url
      class CommercialUrlFrame < Id3v2Frame
        include HasId

        frame_info :WCM, :WCOM, :WCOM

        attr_accessor :url

        # builds the commercial use frame
        #
        # @param url [String] the url
        # @param options [Options::Options] options to use
        # @param id3_version [Integer] the id3 version to build the frame for
        #
        # @return [Id3v2Frame] the resulting id3v2 frame
        def self.build_frame(url, options = nil, id3_version: 3)
          supported?('WCOM', id3_version, options)

          argument_not_nil(url, 'url')

          frame = new(frame_id(id3_version, options), 0, build_id3_flags(id3_version), '')
          frame.url = url
          frame
        end

        def process_content(content)
          @url = content
        end

        def content_to_bytes
          @url
        end
      end
    end
  end
end
