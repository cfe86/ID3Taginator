# frozen_string_literal: true

module Id3Taginator
  module Frames
    module Text
      class CopyrightFrame < Id3v2Frame
        include HasId

        frame_info :TCR, :TCOP, :TCOP

        attr_accessor :holder, :year

        # builds the copyright frame
        #
        # @param year [String] the 4 character year e.g. 2020
        # @param holder [String] the copyright holder
        # @param options [Options::Options] options to use
        # @param id3_version [Integer] the id3 version to build the frame for
        #
        # @return [Id3v2Frame] the resulting id3v2 frame
        def self.build_frame(year, holder, options = nil, id3_version: 3)
          supported?('TCOP', id3_version, options)

          year = year.to_s unless year.nil?

          argument_exactly_chars(year, 'year', 4)
          argument_not_nil(holder, 'holder')

          frame = new(frame_id(id3_version, options), 0, build_id3_flags(id3_version), '')
          frame.year = year
          frame.holder = holder
          frame
        end

        def process_content(content)
          content = decode_using_encoding_byte(content)
          if content[4] == ' '
            @year = content[0..3]
            content = content[4..-1]
          else
            @year = 1970
          end

          content = content.gsub('Copyright ©', '')
          @holder = content.strip
        end

        def content_to_bytes
          content = "#{@year} #{@holder} Copyright ©"
          encode_and_add_encoding_byte(content)
        end
      end
    end
  end
end
