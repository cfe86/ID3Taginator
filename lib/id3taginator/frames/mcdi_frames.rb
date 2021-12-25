# frozen_string_literal: true

module Id3Taginator
  module Frames
    module McdiFrames
      include Frames::Frameable

      # extracts the music cd identifier (MCDI/MCI)
      #
      # @return [String, nil] returns the music cd identifier
      def music_cd_identifier
        find_frame(Mcdi::MusicCDIdentifierFrame.frame_id(@major_version, @options))&.cd_toc
      end

      # sets the music cd identifier (MCDI/MCI)
      #
      # @param cd_toc [String] sets the music cd identifier
      def music_cd_identifier=(cd_toc)
        set_frame_fields(Mcdi::MusicCDIdentifierFrame, [:@cd_toc], cd_toc)
      end
    end
  end
end
