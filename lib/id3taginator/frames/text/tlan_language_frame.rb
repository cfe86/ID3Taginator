# frozen_string_literal: true

module Id3Taginator
  module Frames
    module Text
      class LanguageFrame < Id3v2Frame
        include HasId

        frame_info :TLA, :TLAN, :TLAN

        attr_accessor :languages

        # builds the language frame
        #
        # @param languages [Array<String>, String] the 3 character language(s)
        # @param options [Options::Options] options to use
        # @param id3_version [Integer] the id3 version to build the frame for
        #
        # @return [Id3v2Frame] the resulting id3v2 frame
        def self.build_frame(languages, options = nil, id3_version: 3)
          supported?('TLAN', id3_version, options)

          argument_not_empty(languages, 'languages')

          langs = languages.is_a?(Array) ? languages : [languages]

          raise ArgumentError, 'Languages should be 3 characters, ISO-639-2.' if langs.any? { |l| l.length != 3 }

          frame = new(frame_id(id3_version, options), 0, build_id3_flags(id3_version), '')
          frame.languages = langs
          frame
        end

        def process_content(content)
          languages_str = decode_using_encoding_byte(content)
          @languages = languages_str.split("\x00").map(&:strip)
        end

        def content_to_bytes
          @languages ||= ['und']
          content = @languages.join("\x00")
          content += "\x00" if @languages.length > 1
          encode_and_add_encoding_byte(content)
        end
      end
    end
  end
end
