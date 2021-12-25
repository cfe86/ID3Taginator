# frozen_string_literal: true

module Id3Taginator
  module Frames
    module Mcdi
      class MusicCDIdentifierFrame < Id3v2Frame
        include HasId

        frame_info :MCI, :MCDI, :MCDI

        attr_accessor :cd_toc

        # builds the music cd identifier frame
        #
        # @param cd_toc [String] the cd toc bytes represented as a String (str.bytes)
        # @param options [Options::Options] options to use
        # @param id3_version [Integer] the id3 version to build the frame for
        #
        # @return [Id3v2Frame] the resulting id3v2 frame
        def self.build_frame(cd_toc, options = nil, id3_version: 3)
          supported?('MCDI', id3_version, options)

          argument_not_nil(cd_toc, 'cd_toc')

          frame = new(frame_id(id3_version, options), 0, build_id3_flags(id3_version), '')
          frame.cd_toc = cd_toc
          frame
        end

        def process_content(content)
          @cd_toc = content
        end

        def content_to_bytes
          @cd_toc
        end
      end
    end
  end
end
