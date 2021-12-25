# frozen_string_literal: true

module Id3Taginator
  module Frames
    module Comment
      class CommentFrame < Id3v2Frame
        include HasId

        frame_info :COM, :COMM, :COMM

        attr_accessor :language, :descriptor, :text

        # builds the comment frame
        #
        # @param language [String] the language of the comment (3 characters)
        # @param descriptor [String] description
        # @param text [String] the comment text
        # @param options [Options::Options] options to use
        # @param id3_version [Integer] the id3 version to build the frame for
        #
        # @return [Id3v2Frame] the resulting id3v2 frame
        def self.build_frame(language, descriptor, text, options = nil, id3_version: 3)
          supported?('COMM', id3_version, options)

          argument_not_nil(language, 'language')
          argument_exactly_chars(language, 'language', 3)
          argument_not_nil(text, 'text')
          descriptor ||= ''

          frame = new(frame_id(id3_version, options), 0, build_id3_flags(id3_version), '')
          frame.language = language
          frame.descriptor = descriptor
          frame.text = text
          frame
        end

        def process_content(content)
          stream = StringIO.new(content)
          encoding = find_encoding(stream.readbyte)

          @language = stream.read(3)
          encoded_descriptor = read_stream_until(stream, zero_byte(encoding))
          @descriptor = decode(encoded_descriptor, encoding)
          encoded_text = stream.read
          @text = decode(encoded_text, encoding)
        end

        def content_to_bytes
          encoded_descriptor = encode(@descriptor, null_terminated: true)
          encoded_text = encode(@text)
          merge(default_encoding_destination_byte, @language, encoded_descriptor, encoded_text)
        end
      end
    end
  end
end
