# frozen_string_literal: true

module Id3Taginator
  module Frames
    module Lyrics
      class UnsyncLyricsFrame < Id3v2Frame
        include HasId

        frame_info :ULT, :USLT, :USLT

        attr_accessor :language, :descriptor, :lyrics

        # builds the unsync lyrics frame
        #
        # @param language [String] the lyrics language as 3 character language
        # @param descriptor [String] the description
        # @param lyrics [String] the lyrics text
        # @param options [Options::Options] options to use
        # @param id3_version [Integer] the id3 version to build the frame for
        #
        # @return [Id3v2Frame] the resulting id3v2 frame
        def self.build_frame(language, descriptor, lyrics, options = nil, id3_version: 3)
          supported?('USLT', id3_version, options)

          argument_not_nil(language, 'language')
          argument_exactly_chars(language, 'language', 3)
          argument_not_nil(lyrics, 'lyrics')
          descriptor ||= ''

          frame = new(frame_id(id3_version, options), 0, build_id3_flags(id3_version), '')
          frame.language = language
          frame.descriptor = descriptor
          frame.lyrics = lyrics
          frame
        end

        def process_content(content)
          stream = StringIO.new(content)
          encoding = find_encoding(stream.readbyte)

          @language = stream.read(3)
          encoded_descriptor = read_stream_until(stream, zero_byte(encoding))
          @descriptor = decode(encoded_descriptor, encoding)
          encoded_lyrics = stream.read
          @lyrics = decode(encoded_lyrics, encoding)
        end

        def content_to_bytes
          encrypted_descriptor = encode(@descriptor, null_terminated: true)
          encrypted_lyrics = encode(@lyrics)
          merge(default_encoding_destination_byte, @language, encrypted_descriptor, encrypted_lyrics)
        end
      end
    end
  end
end
