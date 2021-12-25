# frozen_string_literal: true

module Id3Taginator
  module Frames
    module TextFrames
      include Frames::Frameable

      # extracts the album (TALB/TAL)
      #
      # @return [String, nil] returns the Album
      def album
        find_frame(Text::AlbumFrame.frame_id(@major_version, @options))&.album
      end

      # sets the album (TALB/TAL)
      #
      # @param album [String] the album
      def album=(album)
        set_frame_fields(Text::AlbumFrame, [:@album], album)
      end

      # extracts the album (TSOA)
      #
      # @return [String, nil] returns the Album Sort Order
      def album_sort_order
        find_frame(Text::AlbumSortOrderFrame.frame_id(@major_version, @options))&.album
      end

      # sets the album name used for sorting (TSOA)
      #
      # @param album [String] the album for sorting
      def album_sort_order=(album)
        set_frame_fields(Text::AlbumSortOrderFrame, [:@album], album)
      end

      # extracts the performer sort order (TSOP)
      #
      # @return [String, nil] returns the Performer Sort Order
      def performer_sort_order
        find_frame(Text::PerformerSortOrderFrame.frame_id(@major_version, @options))&.performer
      end

      # sets the performer used for sorting (TSOP)
      #
      # @param performer [String] the performer for sorting
      def performer_sort_order=(performer)
        set_frame_fields(Text::PerformerSortOrderFrame, [:@performer], performer)
      end

      # extracts the title sort order (TSOT)
      #
      # @return [String, nil] returns the Title Sort Order
      def title_sort_order
        find_frame(Text::TitleSortOrderFrame.frame_id(@major_version, @options))&.title
      end

      # sets the title used for sorting (TSOT)
      #
      # @param title [String] the title for sorting
      def title_sort_order=(title)
        set_frame_fields(Text::TitleSortOrderFrame, [:@title], title)
      end

      # extracts the bpm (TBPM/TBP)
      #
      # @return [String, nil] returns the bpm
      def bpm
        find_frame(Text::BPMFrame.frame_id(@major_version, @options))&.bpm
      end

      # sets the bpm (TBPM/TBP)
      #
      # @param bpm [String, Integer] the bpm
      def bpm=(bpm)
        set_frame_fields(Text::BPMFrame, [:@bpm], bpm)
      end

      # extracts the composer (TCOM/TCM)
      #
      # @return [Array<String>] returns the composer
      def composers
        frame = find_frame(Text::ComposerFrame.frame_id(@major_version, @options))
        return [] if frame.nil?

        frame.composers
      end

      # sets the composers (TCOM/TCM)
      #
      # @param composers [Array<String>, String] the composers (or one composer)
      def composers=(composers)
        set_frame_fields(Text::ComposerFrame, [:@composers], composers)
      end

      # extracts the genres (TCON/TCO)
      #
      # @return [Array<String>] returns the composer
      def genres
        frame = find_frame(Text::GenreFrame.frame_id(@major_version, @options))
        return [] if frame.nil?

        frame.genres
      end

      # sets the genres (TCON/TCO)
      #
      # @param genres [Array<String, Symbol>] the genres as String or Symbols
      def genres=(genres)
        set_frame_fields(Text::GenreFrame, [:@genres], genres)
      end

      # extracts the copyright (TCOP/TCR)
      #
      # @return [Frames::Text::Entities::Copyright, nil] returns the copyright
      def copyright
        frame = find_frame(Text::CopyrightFrame.frame_id(@major_version, @options))
        return nil if frame.nil?

        Text::Entities::Copyright.new(frame.year, frame.holder)
      end

      # sets the copyright (TCOP/TCR)
      #
      # @param copyright [Frames::Text::Entities::Copyright] the copyright
      def copyright=(copyright)
        set_frame_fields(Text::CopyrightFrame, %i[@year @holder], copyright.year, copyright.holder)
      end

      # extracts the date (TDAT/TDA)
      #
      # @return [Frames::Text::Entities::Date, nil] returns the date
      def date
        frame = find_frame(Text::DateFrame.frame_id(@major_version, @options))
        return nil if frame.nil?

        Text::Entities::Date.new(frame.month, frame.day)
      end

      # sets the date (TDAT/TDA)
      #
      # @param date [Frames::Text::Entities::Date] the date
      def date=(date)
        set_frame_fields(Text::DateFrame, %i[@month @day], date.month, date.day)
      end

      # extracts the playlist delay (TDLY/TDY)
      #
      # @return [String, nil] returns the date
      def playlist_delay
        find_frame(Text::PlaylistDelayFrame.frame_id(@major_version, @options))&.delay
      end

      # sets the playlist delay (TDLY/TDY)
      #
      # @param delay_in_ms [String, Integer] the delay in ms
      def playlist_delay=(delay_in_ms)
        set_frame_fields(Text::PlaylistDelayFrame, [:@delay], delay_in_ms)
      end

      # extracts the encoded by (TENC/TEN)
      #
      # @return [String, nil] returns the encoded by
      def encoded_by
        find_frame(Text::EncodedByFrame.frame_id(@major_version, @options))&.encoded_by
      end

      # sets the playlist delay (TENC/TEN)
      #
      # @param encoded_by [String] the encoded by
      def encoded_by=(encoded_by)
        set_frame_fields(Text::EncodedByFrame, [:@encoded_by], encoded_by)
      end

      # extracts the writers (TEXT/TXT)
      #
      # @return [Array<String>] returns the writers
      def writers
        frame = find_frame(Text::WritersFrame.frame_id(@major_version, @options))
        return [] if frame.nil?

        frame.writers
      end

      # sets the writers (TENC/TEN)
      #
      # @param writers [Array<String>, String] the writers
      def writers=(writers)
        set_frame_fields(Text::WritersFrame, [:@writers], writers)
      end

      # extracts the file type (TFLT/TFT)
      #
      # @return [String, nil] returns the file type
      def file_type
        find_frame(Text::FileTypeFrame.frame_id(@major_version, @options))&.file_type
      end

      # sets the file type (TFLT/TFT)
      #
      # @param file_type [String] the file type
      def file_type=(file_type)
        set_frame_fields(Text::FileTypeFrame, [:@file_type], file_type)
      end

      # extracts the time (TIME/TIM)
      #
      # @return [Frames::Text::Entities::Time, nil] returns the time
      def time
        frame = find_frame(Text::TimeFrame.frame_id(@major_version, @options))
        return nil if frame.nil?

        Text::Entities::Time.new(frame.hours, frame.minutes)
      end

      # sets the time (TIME/TIM)
      #
      # @param time [Frames::Text::Entities::Time] the time
      def time=(time)
        set_frame_fields(Text::TimeFrame, %i[@hours @minutes], time.hours, time.minutes)
      end

      # extracts the content group description (TIT1/TT1)
      #
      # @return [String, nil] returns content group description
      def content_group_description
        find_frame(Text::ContentGroupDescriptionFrame.frame_id(@major_version, @options))&.content_description
      end

      # sets the content group description (TIT1/TT1)
      #
      # @param content_group_description [String] the content group description
      def content_group_description=(content_group_description)
        set_frame_fields(Text::ContentGroupDescriptionFrame, [:@content_group_description], content_group_description)
      end

      # extracts the title (TIT2/TT2)
      #
      # @return [String, nil] returns title
      def title
        find_frame(Text::TitleFrame.frame_id(@major_version, @options))&.title
      end

      # sets the title (TIT2/TT2)
      #
      # @param title [String] the title
      def title=(title)
        set_frame_fields(Text::TitleFrame, [:@title], title)
      end

      # extracts the subtitle (TIT3/TT3)
      #
      # @return [String, nil] returns subtitle
      def subtitle
        find_frame(Text::SubtitleFrame.frame_id(@major_version, @options))&.subtitle
      end

      # sets the subtitle (TIT3/TT3)
      #
      # @param subtitle [String] the subtitle
      def subtitle=(subtitle)
        set_frame_fields(Text::SubtitleFrame, [:@subtitle], subtitle)
      end

      # extracts the initial key (<= 3 characters) (TKEY/TKE)
      #
      # @return [String, nil] returns the initial key
      def initial_key
        find_frame(Text::InitialKeyFrame.frame_id(@major_version, @options))&.initial_key
      end

      # sets the initial key (<= 3 characters) (TKEY/TKE)
      #
      # @param initial_key [String] the initial key (<= 3 characters)
      def initial_key=(initial_key)
        set_frame_fields(Text::InitialKeyFrame, [:@initial_key], initial_key)
      end

      # extracts the languages (TLAN/TLA)
      #
      # @return [Array<String>] returns the languages
      def languages
        frame = find_frame(Text::LanguageFrame.frame_id(@major_version, @options))
        return [] if frame.nil?

        frame.languages
      end

      # sets the languages (TLAN/TLA)
      #
      # @param languages [Array<String>, String] the languages (3 character code languages)
      def languages=(languages)
        set_frame_fields(Text::LanguageFrame, [:@languages], languages)
      end

      # extracts the length in seconds (TLEN/TLE)
      #
      # @return [String, nil] returns the length
      def length
        find_frame(Text::LengthFrame.frame_id(@major_version, @options))&.length
      end

      # sets the length in seconds (TLEN/TLE)
      #
      # @param length [String, Integer] the length in seconds
      def length=(length)
        set_frame_fields(Text::LengthFrame, [:@length], length)
      end

      # extracts the media type (TMED/TMT)
      #
      # @return [String, nil] returns the media type
      def media_type
        find_frame(Text::MediaTypeFrame.frame_id(@major_version, @options))&.media_type
      end

      # sets the media type (TMED/TMT)
      #
      # @param media_type [String] the media type
      def media_type=(media_type)
        set_frame_fields(Text::MediaTypeFrame, [:@media_type], media_type)
      end

      # extracts the original album (TOAL/TOT)
      #
      # @return [String, nil] returns the original album
      def original_album
        find_frame(Text::OriginalAlbumFrame.frame_id(@major_version, @options))&.original_album
      end

      # sets the original album (TOAL/TOT)
      #
      # @param original_album [String] the original album
      def original_album=(original_album)
        set_frame_fields(Text::OriginalAlbumFrame, [:@original_album], original_album)
      end

      # extracts the original file name (TOFN/TOF)
      #
      # @return [String, nil] returns the original file name
      def original_filename
        find_frame(Text::OriginalFilenameFrame.frame_id(@major_version, @options))&.original_filename
      end

      # sets the original filename (TOFN/TOF)
      #
      # @param original_filename [String] the original filename
      def original_filename=(original_filename)
        set_frame_fields(Text::OriginalFilenameFrame, [:@original_filename], original_filename)
      end

      # extracts the original writers (TOLY/TOL)
      #
      # @return [Array<String>] returns the original writers
      def original_writers
        frame = find_frame(Text::OriginalWritersFrame.frame_id(@major_version, @options))
        return [] if frame.nil?

        frame.original_writers
      end

      # sets the original writers (TOLY/TOL)
      #
      # @param original_writers [Array<String>, String] the original writers
      def original_writers=(original_writers)
        set_frame_fields(Text::OriginalWritersFrame, [:@original_writers], original_writers)
      end

      # extracts the original artists (TOPE, :TOA)
      #
      # @return [Array<String>] returns the original artists
      def original_artists
        frame = find_frame(Text::OriginalArtistsFrame.frame_id(@major_version, @options))
        return [] if frame.nil?

        frame.original_artists
      end

      # sets the original artists (TOPE, :TOA)
      #
      # @param original_artists [Array<String>, String] the original artists
      def original_artists=(original_artists)
        set_frame_fields(Text::OriginalArtistsFrame, [:@original_artists], original_artists)
      end

      # extracts the original release year (TORY, :TOR)
      #
      # @return [String, nil] returns the original album
      def original_release_year
        find_frame(Text::OriginalReleaseYearFrame.frame_id(@major_version, @options))&.original_release_year
      end

      # sets the original release year (TORY, :TOR)
      #
      # @param original_release_year [String, Integer] the original release year
      def original_release_year=(original_release_year)
        set_frame_fields(Text::OriginalReleaseYearFrame, [:@original_release_year], original_release_year)
      end

      # extracts the file owner (TOWN)
      #
      # @return [String, nil] returns the file owner
      def file_owner
        find_frame(Text::FileOwnerFrame.frame_id(@major_version, @options))&.file_owner
      end

      # sets the file owner (TOWN)
      #
      # @param file_owner [String] the file owner
      def file_owner=(file_owner)
        set_frame_fields(Text::FileOwnerFrame, [:@file_owner], file_owner)
      end

      # extracts the artists (TPE1/TP1)
      #
      # @return [Array<String>] returns the artists
      def artists
        frame = find_frame(Text::ArtistsFrame.frame_id(@major_version, @options))
        return [] if frame.nil?

        frame.artists
      end

      # sets the artists (TPE1/TP1)
      #
      # @param artists [Array<String>, String] the artists
      def artists=(artists)
        set_frame_fields(Text::ArtistsFrame, [:@artists], artists)
      end

      # extracts the album artist (TPE2/TP2)
      #
      # @return [String, nil] returns the album artist
      def album_artist
        find_frame(Text::AlbumArtistFrame.frame_id(@major_version, @options))&.album_artist
      end

      # sets the album artist (TPE2/TP2)
      #
      # @param album_artist [String] the album artist
      def album_artist=(album_artist)
        set_frame_fields(Text::AlbumArtistFrame, [:@album_artist], album_artist)
      end

      # extracts the conductor (TPE3/TP3)
      #
      # @return [String, nil] returns the conductor
      def conductor
        find_frame(Text::ConductorFrame.frame_id(@major_version, @options))&.conductor
      end

      # sets the conductor (TPE3/TP3)
      #
      # @param conductor [String] the conductor
      def conductor=(conductor)
        set_frame_fields(Text::ConductorFrame, [:@conductor], conductor)
      end

      # extracts the modified by (TPE4/TP4)
      #
      # @return [String, nil] returns the modified by
      def modified_by
        find_frame(Text::ModifiedByFrame.frame_id(@major_version, @options))&.modified_by
      end

      # sets the modified by (TPE4/TP4)
      #
      # @param modified_by [String] the modified_by
      def modified_by=(modified_by)
        set_frame_fields(Text::ModifiedByFrame, [:@modified_by], modified_by)
      end

      # extracts the part of set, e.g. CD 1/2 (TPOS/TPA)
      #
      # @return [Frames::Text::Entities::PartOfSet, nil] returns the part of set
      def part_of_set
        frame = find_frame(Text::PartOfSetFrame.frame_id(@major_version, @options))
        return nil if frame.nil?

        Text::Entities::PartOfSet.new(frame.part, frame.total)
      end

      # sets the part of set (TPOS/TPA)
      #
      # @param part_of_set [Frames::Text::Entities::PartOfSet] the part of set
      def part_of_set=(part_of_set)
        set_frame_fields(Text::PartOfSetFrame, %i[@part @htotal], part_of_set.part, part_of_set.total)
      end

      # extracts the publisher (TPUB/TPB)
      #
      # @return [String, nil] returns the publisher
      def publisher
        find_frame(Text::PublisherFrame.frame_id(@major_version, @options))&.publisher
      end

      # sets the publisher (TPUB/TPB)
      #
      # @param publisher [String] the publisher
      def publisher=(publisher)
        set_frame_fields(Text::PublisherFrame, [:@publisher], publisher)
      end

      # extracts the track number (TRCK/TRK)
      #
      # @return [Frames::Text::Entities::TrackNumber, nil] returns the track number
      def track_number
        frame = find_frame(Text::TrackNumberFrame.frame_id(@major_version, @options))
        return nil if frame.nil?

        Text::Entities::TrackNumber.new(frame.track_number, frame.total)
      end

      # sets the track number (TRCK/TRK)
      #
      # @param track_number [Frames::Text::Entities::TrackNumber] the track number
      def track_number=(track_number)
        set_frame_fields(Text::TrackNumberFrame, %i[@track_number @htotal], track_number.track_number,
                         track_number.total)
      end

      # extracts the recording dates (TRDA/TRD)
      #
      # @return [Array<String>] returns the recording dates
      def recording_dates
        frame = find_frame(Text::RecordingDatesFrame.frame_id(@major_version, @options))
        return [] if frame.nil?

        frame.recording_dates
      end

      # sets the recording dates (TRDA/TRD)
      #
      # @param recording_dates [Array<String>, String] the recording date(s)
      def recording_dates=(recording_dates)
        set_frame_fields(Text::RecordingDatesFrame, [:@recording_dates], recording_dates)
      end

      # extracts the internet radio station name (TRSN)
      #
      # @return [String, nil] returns the internet radio station name
      def internet_radio_station_name
        find_frame(Text::InternetRadioStationFrame.frame_id(@major_version, @options))&.station_name
      end

      # sets the internet radio station (TRSN)
      #
      # @param station_name [String] the internet radio station
      def internet_radio_station_name=(station_name)
        set_frame_fields(Text::InternetRadioStationFrame, [:@station_name], station_name)
      end

      # extracts the file size in bytes excluding the id3v2 tag size (TSIZ/TSI)
      #
      # @return [String, nil] returns the size in bytes
      def size
        find_frame(Text::SizeFrame.frame_id(@major_version, @options))&.size
      end

      # sets the file size in bytes excluding the id3v2 tag size (TSIZ/TSI)
      #
      # @param size [String, Integer] the size in bytes
      def size=(size)
        set_frame_fields(Text::SizeFrame, [:@size], size)
      end

      # extracts the ISRC number (12 characters) (TSRC/TRC)
      #
      # @return [String, nil] returns the ISRC number
      def isrc
        find_frame(Text::ISRCFrame.frame_id(@major_version, @options))&.isrc
      end

      # sets the ISRC number (TSRC/TRC)
      #
      # @param isrc [String] the ISRC number (12 characters)
      def isrc=(isrc)
        set_frame_fields(Text::ISRCFrame, [:@isrc], isrc)
      end

      # extracts the encoder (TSSE/TSS)
      #
      # @return [String, nil] returns the Encoder
      def encoder
        find_frame(Text::EncoderFrame.frame_id(@major_version, @options))&.encoder
      end

      # sets the Encoder (TSSE/TSS)
      #
      # @param encoder [String] the Encoder
      def encoder=(encoder)
        set_frame_fields(Text::EncoderFrame, [:@encoder], encoder)
      end

      # extracts the year (TYER/TYE)
      #
      # @return [String, nil] returns the year
      def year
        find_frame(Text::YearFrame.frame_id(@major_version, @options))&.year
      end

      # sets the Year (TYER/TYE)
      #
      # @param year [String, Integer] the Year, must be 4 characters long e.g. 2020
      def year=(year)
        set_frame_fields(Text::YearFrame, [:@year], year)
      end

      # extracts the user text infos (TXXX/TXX)
      #
      # @return [Array<Frames::Text::Entities::UserInfo>] returns the User Text Infos
      def user_custom_text_information
        frame = find_frames(Text::UserTextInfoFrame.frame_id(@major_version, @options))
        return [] if frame.nil? || frame.empty?

        frame.map { |f| Text::Entities::UserInfo.new(f.description, f.content) }
      end

      # adds a user text info (TXXX/TXX)
      # Multiple ones can be added, as long as they have different description
      #
      # @param information [Frames::Text::Entities::UserInfo] the user text info to add
      def user_custom_text_information=(information)
        set_frame_fields_by_selector(Text::UserTextInfoFrame, %i[@icontent],
                                     ->(f) { f.description == information.description },
                                     information.content, information.description)
      end

      alias add_user_custom_text_information user_custom_text_information=

      # removes a user text info for the specific description (TXXX/TXX)
      #
      # @param description [String] the description
      def remove_user_custom_text_information(description)
        @frames.delete_if do |f|
          f.identifier == Text::UserTextInfoFrame.frame_id(@major_version, @options) && f.description == description
        end
      end
    end
  end
end
