# frozen_string_literal: true

module Id3Taginator
  module Frames
    module LyricsFrames
      include Frames::Frameable

      # extracts the unsync lyrics (USLT/ULT)
      #
      # @return [Array<Frames::Lyrics::Entities::UnsyncLyrics>] returns the Lyrics
      def unsync_lyrics
        frame = find_frames(Lyrics::UnsyncLyricsFrame.frame_id(@major_version, @options))
        return [] if frame.nil? || frame.empty?

        frame.map { |f| Lyrics::Entities::UnsyncLyrics.new(f.language, f.descriptor, f.lyrics) }
      end

      # adds an unsync lyrics. (USLT/ULT)
      # Lyrics with the same language and descriptor will be updated.
      #
      # @param lyrics [Frames::Lyrics::Entities::UnsyncLyrics] the lyrics to add
      def unsync_lyrics=(lyrics)
        set_frame_fields_by_selector(Lyrics::UnsyncLyricsFrame, %i[@language @descriptor @lyrics],
                                     ->(f) { f.language == lyrics.language && f.descriptor == lyrics.descriptor },
                                     lyrics.language, lyrics.descriptor, lyrics.lyrics)
      end

      alias add_unsync_lyrics unsync_lyrics=

      # removes an unsync lyrics for the specific language and descriptor
      #
      # @param language [String] the language
      # @param descriptor [String] the descriptor
      def remove_unsync_lyrics(language, descriptor)
        @frames.delete_if do |f|
          f.identifier == Lyrics::UnsyncLyricsFrame.frame_id(@major_version, @options) && f.language == language &&
            f.descriptor == descriptor
        end
      end
    end
  end
end
