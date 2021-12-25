# frozen_string_literal: true

module Id3Taginator
  module Frames
    module Url
      class UserUrlLinkFrame < Id3v2Frame
        include HasId

        frame_info :WXX, :WXXX, :WXXX

        attr_accessor :description, :url

        # builds the custom user url link frame
        #
        # @param description [String] the description
        # @param url [String] the url
        # @param options [Options::Options] options to use
        # @param id3_version [Integer] the id3 version to build the frame for
        #
        # @return [Id3v2Frame] the resulting id3v2 frame
        def self.build_frame(description, url, options = nil, id3_version: 3)
          supported?('WXXX', id3_version, options)

          argument_not_nil(description, 'description')
          argument_not_nil(url, 'url')

          frame = new(frame_id(id3_version, options), 0, build_id3_flags(id3_version), '')
          frame.description = description
          frame.url = url
          frame
        end

        def process_content(content)
          content_io = StringIO.new(content)
          encoding_byte = content_io.getbyte
          encoding = find_encoding(encoding_byte)

          encoded_description = read_stream_until(content_io, zero_byte(encoding))
          @description = decode(encoded_description, encoding)
          @url = content_io.read
        end

        def content_to_bytes
          encoded_description = encode(@description, null_terminated: true)
          merge(default_encoding_destination_byte, encoded_description, @url)
        end
      end
    end
  end
end
