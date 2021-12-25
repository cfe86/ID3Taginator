# frozen_string_literal: true

module Id3Taginator
  module Frames
    class Id3v2FrameFactory

      BUFFER_FRAMES = [Buffer::RecommendedBufferSizeFrame].freeze

      COMMENT_FRAMES = [Comment::CommentFrame].freeze

      COUNT_FRAMES = [Count::PopularityFrame, Count::PlayCounterFrame].freeze

      ENCRYPTION_FRAMES = [Encryption::AudioEncryptionFrame, Encryption::EncryptionMethodFrame].freeze

      GEO_FRAMES = [Geo::GeneralEncapsulatedObjectFrame].freeze

      GROUPING_FRAMES = [Grouping::GroupIdentificationFrame, Grouping::GroupingFrame].freeze

      IPL_FRAMES = [Ipl::InvolvedPeopleFrame].freeze

      LYRICS_FRAMES = [Lyrics::UnsyncLyricsFrame].freeze

      MCDI_FRAMES = [Mcdi::MusicCDIdentifierFrame].freeze

      PICTURE_FRAMES = [Picture::PictureFrame].freeze

      PRIVATE_FRAMES = [Private::PrivateFrame].freeze

      TEXT_FRAMES = [Text::AlbumFrame, Text::BPMFrame, Text::ComposerFrame, Text::GenreFrame, Text::CopyrightFrame,
                     Text::DateFrame, Text::PlaylistDelayFrame, Text::EncodedByFrame, Text::WritersFrame,
                     Text::FileTypeFrame, Text::TimeFrame, Text::ContentGroupDescriptionFrame, Text::TitleFrame,
                     Text::SubtitleFrame, Text::InitialKeyFrame, Text::LanguageFrame, Text::LengthFrame,
                     Text::MediaTypeFrame, Text::OriginalAlbumFrame, Text::OriginalFilenameFrame,
                     Text::OriginalWritersFrame, Text::OriginalArtistsFrame, Text::OriginalReleaseYearFrame,
                     Text::FileOwnerFrame, Text::ArtistsFrame, Text::AlbumArtistFrame, Text::ConductorFrame,
                     Text::ModifiedByFrame, Text::PartOfSetFrame, Text::PublisherFrame, Text::TrackNumberFrame,
                     Text::RecordingDatesFrame, Text::InternetRadioStationFrame, Text::SizeFrame,
                     Text::AlbumSortOrderFrame, Text::PerformerSortOrderFrame, Text::TitleSortOrderFrame,
                     Text::ISRCFrame, Text::EncoderFrame, Text::UserTextInfoFrame, Text::YearFrame].freeze

      TOS_FRAMES = [Tos::OwnershipFrame, Tos::TermsOfUseFrame].freeze

      UFID_FRAMES = [Ufid::UniqueFileIdentifierFrame].freeze

      URL_FRAMES = [Url::CommercialUrlFrame, Url::CopyrightUrlFrame, Url::OfficialFileWebpageFrame,
                    Url::OfficialArtistWebpageFrame, Url::OfficialSourceWebpageFrame,
                    Url::OfficialAudioRadioStationHomepageFrame, Url::PaymentUrlFrame,
                    Url::OfficialPublisherWebpageFrame, Url::UserUrlLinkFrame].freeze

      # Constructor
      #
      # @param file [StringIO, IO, File] the data stream
      # @param version [Integer] the Id3tag major version - 2, 3 or 4
      # @param options [Options::Options] the options to use
      def initialize(file, version, options)
        @file = file
        @version = version
        @options = options
      end

      # reads the next frame in the data stream
      #
      # @return [Id3v2Frame, nil] returns the parsed Id3v2 frame or nil of no frame is found (end of Tag and\or
      # only padding left)
      def next_frame
        frame_id = @version == 2 ? @file.read(3) : @file.read(4)
        return nil if frame_id.bytes.all?(&:zero?)

        frame = frame_for_id(frame_id)
        case @version
        when 2
          frame&.build_v2_frame(frame_id, @file, @options)
        when 3
          frame&.build_v3_frame(frame_id, @file, @options)
        when 4
          frame&.build_v4_frame(frame_id, @file, @options)
        else
          raise Errors::Id3TagError, "id3v2.#{@version} is not supported."
        end
      end

      # returns the frame for the given frame id
      #
      # @param frame_id [String] the frame id to get the Frame for
      #
      # @return [Class<Id3v2Frame>] the frame for the given frame id
      def frame_for_id(frame_id)
        frame = (BUFFER_FRAMES + COMMENT_FRAMES + COUNT_FRAMES + ENCRYPTION_FRAMES + GEO_FRAMES + GROUPING_FRAMES +
          IPL_FRAMES + LYRICS_FRAMES + MCDI_FRAMES + PICTURE_FRAMES + PRIVATE_FRAMES + TOS_FRAMES + TEXT_FRAMES +
          UFID_FRAMES + URL_FRAMES).find { |f| f.frame_id(@version, @options) == frame_id.to_sym }
        # noinspection RubyMismatchedReturnType
        frame.nil? ? CustomFrame : frame
      end

      private :frame_for_id
    end
  end
end
