# frozen_string_literal: true

require 'stringio'
require 'zlib'

require 'id3taginator/util/math_util'
require 'id3taginator/util/sync_util'
require 'id3taginator/util/compress_util'

require 'id3taginator/errors/id3_tag_error'

require 'id3taginator/extensions/encodable'
require 'id3taginator/extensions/comparable'
require 'id3taginator/extensions/argument_check'

require 'id3taginator/genres'

require 'id3taginator/options/options'
require 'id3taginator/extensions/optionable'

require 'id3taginator/frames/has_id'

require 'id3taginator/header/id3v23_extended_header'
require 'id3taginator/header/id3v24_extended_header'

require 'id3taginator/frames/id3v23_frame_flags'
require 'id3taginator/frames/id3v24_frame_flags'

require 'id3taginator/frames/id3v2_frame'

require 'id3taginator/frames/buffer/entities/buffer'

require 'id3taginator/frames/count/entities/popularimeter'

require 'id3taginator/frames/geo/entities/encapsulated_object'

require 'id3taginator/frames/lyrics/entities/unsync_lyrics'

require 'id3taginator/frames/private/entities/private_frame'

require 'id3taginator/frames/tos/entities/ownership'
require 'id3taginator/frames/tos/entities/terms_of_use'

require 'id3taginator/frames/ufid/entities/ufid_info'

require 'id3taginator/frames/text/entities/copyright'
require 'id3taginator/frames/text/entities/date'
require 'id3taginator/frames/text/entities/part_of_set'
require 'id3taginator/frames/text/entities/time'
require 'id3taginator/frames/text/entities/track_number'
require 'id3taginator/frames/text/entities/user_info'

require 'id3taginator/frames/url/entities/user_info'

require 'id3taginator/frames/ipl/entities/involved_person'

require 'id3taginator/frames/comment/entities/comment'

require 'id3taginator/frames/picture/entities/picture'

require 'id3taginator/frames/ufid/ufid_unique_file_identifier_frame'

require 'id3taginator/frames/mcdi/mcdi_music_cd_identifier_frame'

require 'id3taginator/frames/encryption/entities/encryption_method'
require 'id3taginator/frames/encryption/entities/audio_encryption'

require 'id3taginator/frames/grouping/entities/group_identification'

require 'id3taginator/frames/text/talb_album_frame'
require 'id3taginator/frames/text/tpe1_artist_frame'
require 'id3taginator/frames/text/tpe2_album_artist_frame'
require 'id3taginator/frames/text/tpe3_conductor_frame'
require 'id3taginator/frames/text/tpe4_modified_by_frame'
require 'id3taginator/frames/text/tbpm_bpm_frame'
require 'id3taginator/frames/text/tcom_composer_frame'
require 'id3taginator/frames/text/tcon_genre_frame'
require 'id3taginator/frames/text/tcop_copyright_frame'
require 'id3taginator/frames/text/tdat_date_frame'
require 'id3taginator/frames/text/tdly_playlist_delay_frame'
require 'id3taginator/frames/text/tenc_encoded_by_frame'
require 'id3taginator/frames/text/text_writers_frame'
require 'id3taginator/frames/text/tflt_file_type_frame'
require 'id3taginator/frames/text/time_time_frame'
require 'id3taginator/frames/text/tit1_content_group_description_frame'
require 'id3taginator/frames/text/tit2_title_frame'
require 'id3taginator/frames/text/tit3_subtitle_frame'
require 'id3taginator/frames/text/tkey_initial_key_frame'
require 'id3taginator/frames/text/tlan_language_frame'
require 'id3taginator/frames/text/tlen_length_frame'
require 'id3taginator/frames/text/tmed_media_type_frame'
require 'id3taginator/frames/text/toal_original_album_frame'
require 'id3taginator/frames/text/tofn_original_filename_frame'
require 'id3taginator/frames/text/toly_original_writers_frame'
require 'id3taginator/frames/text/tope_original_artists_frame'
require 'id3taginator/frames/text/tory_original_release_year_frame'
require 'id3taginator/frames/text/town_file_owner_frame'
require 'id3taginator/frames/text/tpos_part_of_set_frame'
require 'id3taginator/frames/text/tpub_publisher_frame'
require 'id3taginator/frames/text/trck_track_number_frame'
require 'id3taginator/frames/text/trda_recording_dates_frame'
require 'id3taginator/frames/text/trsn_internet_radio_station_frame'
require 'id3taginator/frames/text/tsiz_size_frame'
require 'id3taginator/frames/text/tsoa_album_sort_order_frame'
require 'id3taginator/frames/text/tsop_performer_sort_order_frame'
require 'id3taginator/frames/text/tsot_title_sort_order_frame'
require 'id3taginator/frames/text/tsrc_isrc_frame'
require 'id3taginator/frames/text/tsse_encoder_frame'
require 'id3taginator/frames/text/tyer_year_frame'
require 'id3taginator/frames/text/txxx_user_text_info_frame'

require 'id3taginator/frames/url/wcom_commercial_url_frame'
require 'id3taginator/frames/url/wcop_copyright_url_frame'
require 'id3taginator/frames/url/woaf_official_file_webpage_frame'
require 'id3taginator/frames/url/woar_official_artist_webpage_frame'
require 'id3taginator/frames/url/woas_official_source_webpage_frame'
require 'id3taginator/frames/url/wors_official_radio_station_homepage_frame'
require 'id3taginator/frames/url/wpay_payment_url_frame'
require 'id3taginator/frames/url/wpub_official_publisher_webpage_frame'
require 'id3taginator/frames/url/wxxx_user_url_link_frame'

require 'id3taginator/frames/ipl/ipls_involved_people_frame'

require 'id3taginator/frames/lyrics/uslt_unsync_lyrics_frame'

require 'id3taginator/frames/comment/comm_comment_frame'

require 'id3taginator/frames/picture/apic_picture_frame'

require 'id3taginator/frames/geo/geob_general_encapsulated_object_frame'

require 'id3taginator/frames/count/pcnt_play_counter_frame'
require 'id3taginator/frames/count/popm_popularimeter_frame'

require 'id3taginator/frames/buffer/rbuf_recommended_buffer_size_frame'

require 'id3taginator/frames/tos/user_terms_of_use_frame'
require 'id3taginator/frames/tos/owne_ownership_frame'

require 'id3taginator/frames/encryption/aenc_audio_encryption'
require 'id3taginator/frames/encryption/encr_encryption_method_frame'

require 'id3taginator/frames/grouping/grid_group_identification_frame'
require 'id3taginator/frames/grouping/grp1_grouping_frame'

require 'id3taginator/frames/private/priv_private_frame'

require 'id3taginator/frames/custom_frame'

require 'id3taginator/frames/id3v2_frame_factory'

require 'id3taginator/frames/frameable'
require 'id3taginator/frames/text_frames'
require 'id3taginator/frames/url_frames'
require 'id3taginator/frames/ufid_frames'
require 'id3taginator/frames/ipl_frames'
require 'id3taginator/frames/mcdi_frames'
require 'id3taginator/frames/lyrics_frames'
require 'id3taginator/frames/comment_frames'
require 'id3taginator/frames/picture_frames'
require 'id3taginator/frames/geo_frames'
require 'id3taginator/frames/count_frames'
require 'id3taginator/frames/buffer_frames'
require 'id3taginator/frames/tos_frames'
require 'id3taginator/frames/encryption_frames'
require 'id3taginator/frames/grouping_frames'
require 'id3taginator/frames/private_frames'
require 'id3taginator/frames/custom_frames'

require 'id3taginator/id3v1_tag'
require 'id3taginator/header/id3v2_flags'
require 'id3taginator/id3v2_tag'
require 'id3taginator/id3v22_tag'
require 'id3taginator/id3v23_tag'
require 'id3taginator/id3v24_tag'
require 'id3taginator/audio_file'

module Id3Taginator
  class Id3Taginator
    include Extensions::Optionable

    def initialize(options)
      @options = options
    end

    # builds an audio file
    #
    # @param file [StringIO, IO, File] the file stream
    # @param no_tag_parsing [Boolean] if true, no Id3v2 tag is parsed
    #
    # @return [Id3Taginator::AudioFile] the parsed audio file
    def build_by_file(file, no_tag_parsing: false)
      AudioFile.new(file, @options, no_tag_parsing: no_tag_parsing)
    end

    # builds an audio file
    #
    # @param path [String] path to the mp3 file
    # @param no_tag_parsing [Boolean] if true, no Id3v2 tag is parsed
    #
    # @return [Id3Taginator::AudioFile] the parsed audio file
    def build_by_path(path, no_tag_parsing: false)
      AudioFile.new(File.new(path), @options, no_tag_parsing: no_tag_parsing)
    end

    # builds an audio file
    #
    # @param bytes [String] String representing the byte array of the file
    # @param no_tag_parsing [Boolean] if true, no Id3v2 tag is parsed
    #
    # @return [Id3Taginator::AudioFile] the parsed audio file
    def build_by_bytes(bytes, no_tag_parsing: false)
      AudioFile.new(StringIO.new(bytes), @options, no_tag_parsing: no_tag_parsing)
    end
  end

  # creates an Id3Taginator instance and applies the options to all created audio files
  #
  # @return [Id3Taginator] instance to set global options to be applied to all new audio files
  def self.global_options
    Id3Taginator.new(Options::Options.new)
  end

  # builds an audio file
  #
  # @param path [String] path to the mp3 file
  # @param no_tag_parsing [Boolean] if true, no Id3v2 tag is parsed
  #
  # @return [Id3Taginator::AudioFile] the parsed audio file
  def self.build_by_path(path, options = Options::Options.new, no_tag_parsing: false)
    AudioFile.new(File.new(path), options, no_tag_parsing: no_tag_parsing)
  end

  # builds an audio file
  #
  # @param file [StringIO, IO, File] the file stream
  # @param no_tag_parsing [Boolean] if true, no Id3v2 tag is parsed
  #
  # @return [Id3Taginator::AudioFile] the parsed audio file
  def self.build_by_file(file, options = Options::Options.new, no_tag_parsing: false)
    AudioFile.new(file, options, no_tag_parsing: no_tag_parsing)
  end

  # builds an audio file
  #
  # @param bytes [String] String representing the byte array of the file
  # @param no_tag_parsing [Boolean] if true, no Id3v2 tag is parsed
  #
  # @return [Id3Taginator::AudioFile] the parsed audio file
  def self.build_by_bytes(bytes, options = Options::Options.new, no_tag_parsing: false)
    AudioFile.new(StringIO.new(bytes), options, no_tag_parsing: no_tag_parsing)
  end

  # creates a Recommended Buffer Object
  #
  # @param buffer_size [Integer] the buffer size
  # @param embedded_info_flag [Boolean] true if info embedded, else false
  # @param offset_next_tag [Integer, nil] optional byte offset to the next tag
  def self.create_buffer(buffer_size, embedded_info_flag, offset_next_tag)
    Frames::Buffer::Entities::Buffer.new(buffer_size, embedded_info_flag, offset_next_tag)
  end

  # Creates a Comment Object
  #
  # @param language [String] 3 character language, like eng
  # @param descriptor [String] comment description
  # @param text [String] the comment
  def self.create_comment(language, descriptor, text)
    Frames::Comment::Entities::Comment.new(language, descriptor, text)
  end

  # creates a Popularimeter Object
  #
  # @param email [String] email for the rating
  # @param rating [Integer] rating 0 - 255
  # @param counter [Integer] the counter
  def self.create_popularimeter(email, rating, counter)
    Frames::Count::Entities::Popularimeter.new(email, rating, counter)
  end

  # creates Audio Encryption Object
  #
  # @param owner_id [String] the owner id
  # @param preview_start [Integer] preview start in number of frames
  # @param preview_length [Integer] length of preview in frames
  # @param encryption_info [String] the encryption info
  def self.create_audio_encryption(owner_id, preview_start, preview_length, encryption_info)
    Frames::Encryption::Entities::AudioEncryption.new(owner_id, preview_start, preview_length, encryption_info)
  end

  # creates Encryption Method Object
  #
  # @param owner_id [String] the owner id
  # @param method_symbol [Integer] a number between 0 and 255
  # @param encryption_data [String] encryption data
  def self.create_encryption_method(owner_id, method_symbol, encryption_data)
    Frames::Encryption::Entities::EncryptionMethod.new(owner_id, method_symbol, encryption_data)
  end

  # create encapsulated object
  #
  # @param mime_type [String] the mime type e.g. application/json
  # @param filename [String] the filename
  # @param descriptor [String] description
  # @param object_data [String] object data
  def self.create_encapsulated_object(mime_type, filename, descriptor, object_data)
    Frames::Geo::Entities::EncapsulatedObject.new(mime_type, filename, descriptor, object_data)
  end

  # create group identification object
  #
  # @param owner_id [String] the owner id
  # @param group_symbol [Integer] between 0 and 255
  # @param group_dependant_data [String] data
  def self.create_group_identification(owner_id, group_symbol, group_dependant_data)
    Frames::Grouping::Entities::GroupIdentification.new(owner_id, group_symbol, group_dependant_data)
  end

  # create involved person object
  #
  # @param involvement [String] the involvement
  # @param involvee [String] the involvee
  def self.create_involved_person(involvement, involvee)
    Frames::Ipl::Entities::InvolvedPerson.new(involvement, involvee)
  end

  # create unsync lyrics
  #
  # @param language [String] 3 character language e.g. eng
  # @param descriptor [String] the description
  # @param lyrics [String] the lyrics
  def self.create_unsync_lyrics(language, descriptor, lyrics)
    Frames::Lyrics::Entities::UnsyncLyrics.new(language, descriptor, lyrics)
  end

  # creates a picture object
  #
  # @param mime_type [String] the mime type e.g. images/png, or --> if picture data is a link
  # @param picture_type [Symbol] the picture type as symbol, e.g. :COVER_FRONT (check Picture::PictureType)
  # @param descriptor [String] description
  # @param picture_data [String] the picture data
  # @return [Picture] the picture
  def self.create_picture(mime_type, picture_type, descriptor, picture_data)
    Frames::Picture::Entities::Picture.new(mime_type, picture_type, descriptor, picture_data)
  end

  # the creates a private frame object
  #
  # @param owner_id [String] the owner id
  # @param private_data [String] private data
  def self.create_private_frame(owner_id, private_data)
    Frames::Private::Entities::PrivateFrame.new(owner_id, private_data)
  end

  # creates an ownership object
  #
  # @param price_paid [String] the price e.g. $20.00
  # @param date_of_purchase [String] date of purchase in the form YYYYMMDD
  # @param seller [String] the seller
  def self.create_ownership(price_paid, date_of_purchase, seller)
    Frames::Tos::Entities::Ownership.new(price_paid, date_of_purchase, seller)
  end

  # creates a terms of use object
  #
  # @param language [String] the 3 character language, e.g. eng
  # @param text [String] ToU text
  def self.create_terms_of_use(language, text)
    Frames::Tos::Entities::TermsOfUse.new(language, text)
  end

  # creates a Unique File Identifier object
  #
  # @param owner_id [String] the owner id
  # @param identifier [String] the identifier
  def self.create_unique_file_identifier(owner_id, identifier)
    Frames::Ufid::Entities::UfidInfo.new(owner_id, identifier)
  end

  # creates a custom url link
  #
  # @param description [String] description
  # @param url [String] the url
  def self.create_custom_url_link(description, url)
    Frames::Url::Entities::UserInfo.new(description, url)
  end

  # creates a Copyright Object
  #
  # @param year [String, Integer] the year
  # @param holder [String] the copyright holder
  def self.create_copyright(year, holder)
    Frames::Text::Entities::Copyright.new(year, holder)
  end

  # creates a date object
  #
  # @param month [String, Integer] the month
  # @param day [String, Integer] the day
  def self.create_date(month, day)
    Frames::Text::Entities::Date.new(month, day)
  end

  # creates a part of set, e.g. curr CD / max CD
  #
  # @param part [String, Integer] the part of in the set
  # @param total [String, Integer, nil] the total number of parts, can be nil
  def self.create_part_of_set(part, total)
    Frames::Text::Entities::PartOfSet.new(part, total)
  end

  # creates a Time Object
  #
  # @param hours [String, Integer] hours
  # @param minutes [String, Integer] minutes
  def self.create_time(hours, minutes)
    Frames::Text::Entities::Time.new(hours, minutes)
  end

  # creates a track number object
  #
  # @param track_number [String, Integer] the current track number
  # @param total [Number|String, nil] the total number of tracks, can be nil
  def self.create_track_number(track_number, total)
    Frames::Text::Entities::TrackNumber.new(track_number, total)
  end

  # creates a custom user text info
  #
  # @param description [String] the description
  # @param content [String] the content
  def self.create_custom_user_text_info(description, content)
    Frames::Text::Entities::UserInfo.new(description, content)
  end
end
