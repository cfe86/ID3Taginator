# frozen_string_literal: true

module Id3Taginator
  module Frames
    module Tos
      class TermsOfUseFrame < Id3v2Frame
        include HasId

        frame_info nil, :USER, :USER

        attr_accessor :language, :text

        # builds the terms of use frame
        #
        # @param language [String] the 3 character language of the terms of use
        # @param text [String] the terms of use text
        # @param options [Options::Options] options to use
        # @param id3_version [Integer] the id3 version to build the frame for
        #
        # @return [Id3v2Frame] the resulting id3v2 frame
        def self.build_frame(language, text, options = nil, id3_version: 3)
          supported?('USER', id3_version, options)

          argument_not_nil(language, 'language')
          argument_exactly_chars(language, 'language', 3)
          argument_not_nil(text, 'text')

          frame = new(frame_id(id3_version, options), 0, build_id3_flags(id3_version), '')
          frame.language = language
          frame.text = text
          frame
        end

        def process_content(content)
          stream = StringIO.new(content)
          encoding = find_encoding(stream.readbyte)
          @language = stream.read(3)
          encoded_text = stream.read
          @text = decode(encoded_text, encoding)
        end

        def content_to_bytes
          encoded_text = encode(@text)
          merge(default_encoding_destination_byte, @language, encoded_text)
        end
      end
    end
  end
end
