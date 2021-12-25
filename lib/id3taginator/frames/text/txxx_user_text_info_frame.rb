# frozen_string_literal: true

module Id3Taginator
  module Frames
    module Text
      class UserTextInfoFrame < Id3v2Frame
        include HasId

        frame_info :TXX, :TXXX, :TXXX

        attr_accessor :description, :content

        # builds the user text info frame
        #
        # @param description [String] the description
        # @param content [String] the content
        # @param options [Options::Options] options to use
        # @param id3_version [Integer] the id3 version to build the frame for
        #
        # @return [Id3v2Frame] the resulting id3v2 frame
        def self.build_frame(description, content, options = nil, id3_version: 3)
          supported?('TXXX', id3_version, options)

          argument_not_nil(description, 'description')
          argument_not_nil(content, 'content')

          frame = new(frame_id(id3_version, options), 0, build_id3_flags(id3_version), '')
          frame.description = description
          frame.content = content
          frame
        end

        def process_content(content)
          content_io = StringIO.new(content)
          encoding = find_encoding(content_io.getbyte)

          encoded_description = read_stream_until(content_io, zero_byte(encoding))
          encoded_content = content_io.read
          @description = decode(encoded_description, encoding)
          @content = decode(encoded_content, encoding)
        end

        def content_to_bytes
          encoded_description = encode(@description, null_terminated: true)
          encoded_content = encode(@content)
          merge(default_encoding_destination_byte, encoded_description, encoded_content)
        end
      end
    end
  end
end
