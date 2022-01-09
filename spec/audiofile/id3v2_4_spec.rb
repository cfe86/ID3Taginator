# frozen_string_literal: true

require_relative '../spec_helper'

RSpec.describe Id3Taginator::AudioFile do
  it 'creates full audio file id3v2.4 and writes/reads it correctly' do
    audio_bytes = '00010203 04050607 08091011'
    audio_file = Id3Taginator.build_by_file(hex_string_to_byte_stream(audio_bytes))

    expect(audio_file.id3v2_tag).to be_nil
    tag = audio_file.create_id3v2_4_tag
    add_frames(tag)

    bytes = audio_file.audio_file_to_bytes

    expect(audio_file.id3v2_tag).is_a?(Id3Taginator::Id3v24Tag)
    expect(audio_file.read_audio_data).to eq(hex_string_to_bytes(audio_bytes))

    audio_file_parsed = Id3Taginator.build_by_file(StringIO.new(bytes))

    expect(audio_file.id3v1_tag).to be_nil
    expect(audio_file.id3v2_tag).not_to be_nil

    tag = audio_file.id3v2_tag
    tag_parsed = audio_file_parsed.id3v2_tag

    expect(tag.audio_encryptions).to eq(tag_parsed.audio_encryptions)
    expect(tag.pictures).to eq(tag_parsed.pictures)
    expect(tag.comments).to eq(tag_parsed.comments)
    expect(tag.encryption_methods).to eq(tag_parsed.encryption_methods)
    expect(tag.encapsulated_objects).to eq(tag_parsed.encapsulated_objects)
    expect(tag.group_identifications).to eq(tag_parsed.group_identifications)
    expect(tag.grouping).to eq(tag_parsed.grouping)
    expect(tag.involved_people).to eq(tag_parsed.involved_people)
    expect(tag.music_cd_identifier).to eq(tag_parsed.music_cd_identifier)
    expect(tag.play_counter).to eq(tag_parsed.play_counter)
    expect(tag.popularity).to eq(tag_parsed.popularity)
    expect(tag.recommended_buffer_size).to eq(tag_parsed.recommended_buffer_size)
    expect(tag.ownership).to eq(tag_parsed.ownership)
    expect(tag.private_frames).to eq(tag_parsed.private_frames)
    expect(tag.album).to eq(tag_parsed.album)
    expect(tag.bpm).to eq(tag_parsed.bpm)
    expect(tag.composers).to eq(tag_parsed.composers)
    expect(tag.genres).to eq(tag_parsed.genres)
    expect(tag.copyright).to eq(tag_parsed.copyright)
    expect(tag.date).to eq(tag_parsed.date)
    expect(tag.playlist_delay).to eq(tag_parsed.playlist_delay)
    expect(tag.encoded_by).to eq(tag_parsed.encoded_by)
    expect(tag.writers).to eq(tag_parsed.writers)
    expect(tag.file_type).to eq(tag_parsed.file_type)
    expect(tag.time).to eq(tag_parsed.time)
    expect(tag.content_group_description).to eq(tag_parsed.content_group_description)
    expect(tag.title).to eq(tag_parsed.title)
    expect(tag.subtitle).to eq(tag_parsed.subtitle)
    expect(tag.initial_key).to eq(tag_parsed.initial_key)
    expect(tag.languages).to eq(tag_parsed.languages)
    expect(tag.length).to eq(tag_parsed.length)
    expect(tag.media_type).to eq(tag_parsed.media_type)
    expect(tag.original_album).to eq(tag_parsed.original_album)
    expect(tag.original_filename).to eq(tag_parsed.original_filename)
    expect(tag.original_writers).to eq(tag_parsed.original_writers)
    expect(tag.original_artists).to eq(tag_parsed.original_artists)
    expect(tag.original_release_year).to eq(tag_parsed.original_release_year)
    expect(tag.file_owner).to eq(tag_parsed.file_owner)
    expect(tag.artists).to eq(tag_parsed.artists)
    expect(tag.album_artist).to eq(tag_parsed.album_artist)
    expect(tag.conductor).to eq(tag_parsed.conductor)
    expect(tag.modified_by).to eq(tag_parsed.modified_by)
    expect(tag.part_of_set).to eq(tag_parsed.part_of_set)
    expect(tag.publisher).to eq(tag_parsed.publisher)
    expect(tag.track_number).to eq(tag_parsed.track_number)
    expect(tag.recording_dates).to eq(tag_parsed.recording_dates)
    expect(tag.internet_radio_station_name).to eq(tag_parsed.internet_radio_station_name)
    expect(tag.album_sort_order).to eq(tag_parsed.album_sort_order)
    expect(tag.performer_sort_order).to eq(tag_parsed.performer_sort_order)
    expect(tag.title_sort_order).to eq(tag_parsed.title_sort_order)
    expect(tag.isrc).to eq(tag_parsed.isrc)
    expect(tag.encoder).to eq(tag_parsed.encoder)
    expect(tag.user_custom_text_information).to eq(tag_parsed.user_custom_text_information)
    expect(tag.year).to eq(tag_parsed.year)
    expect(tag.unique_file_identifiers).to eq(tag_parsed.unique_file_identifiers)
    expect(tag.terms_of_use).to eq(tag_parsed.terms_of_use)
    expect(tag.unsync_lyrics).to eq(tag_parsed.unsync_lyrics)
    expect(tag.commercial_information_url).to eq(tag_parsed.commercial_information_url)
    expect(tag.copyright_information_url).to eq(tag_parsed.copyright_information_url)
    expect(tag.official_audio_file_url).to eq(tag_parsed.official_audio_file_url)
    expect(tag.official_artist_url).to eq(tag_parsed.official_artist_url)
    expect(tag.official_source_url).to eq(tag_parsed.official_source_url)
    expect(tag.official_radio_station_homepage).to eq(tag_parsed.official_radio_station_homepage)
    expect(tag.payment_url).to eq(tag_parsed.payment_url)
    expect(tag.official_publisher_webpage).to eq(tag_parsed.official_publisher_webpage)
    expect(tag.user_custom_url_links).to eq(tag_parsed.user_custom_url_links)

    expect(audio_file_parsed.read_audio_data).to eq(hex_string_to_bytes(audio_bytes))
    expect(audio_file_parsed.id3v2_tag).is_a?(Id3Taginator::Id3v24Tag)

    remove_frames(tag)

    expect(tag.number_of_frames).to eq(0)
  end

  it 'does not read size frame per default' do
    audio_bytes = '00010203 04050607 08091011'
    audio_file = Id3Taginator.build_by_file(hex_string_to_byte_stream(audio_bytes))
    audio_file.ignore_v24_frame_error(ignore = false)

    expect(audio_file.id3v2_tag).to be_nil
    tag = audio_file.create_id3v2_4_tag
    expect { tag.size = 42 }.to raise_error(Id3Taginator::Errors::Id3TagError)
  end

  it 'does read size frame per default' do
    audio_bytes = '00010203 04050607 08091011'
    audio_file = Id3Taginator.build_by_file(hex_string_to_byte_stream(audio_bytes))
    audio_file.ignore_v24_frame_error

    expect(audio_file.id3v2_tag).to be_nil
    tag = audio_file.create_id3v2_4_tag
    tag.size = 42

    expect(tag.size).to eq('42')
  end

  def add_frames(tag)
    tag.add_audio_encryption(Id3Taginator.create_audio_encryption('owner_id', 42, 20, 'enc info'))
    tag.add_picture(Id3Taginator.create_picture_from_data('images/png', :COVER_FRONT,
                                                          'description', 'front cover'))
    tag.add_picture(Id3Taginator.create_picture_from_data('images/png', :COVER_BACK,
                                                          'description', 'back cover'))
    tag.comment = Id3Taginator.create_comment('eng', 'descriptor', 'comment')
    tag.encryption_methods = Id3Taginator.create_encryption_method('owner_id', 0x00, 'enc data')
    tag.encapsulated_object = Id3Taginator.create_encapsulated_object('images/png', 'filename', 'descriptor', 'data')
    tag.add_group_identification(Id3Taginator.create_group_identification('owner_id', 42, 'data'))
    tag.grouping = 42
    tag.involved_people = [Id3Taginator.create_involved_person('involv1', 'involvee1'),
                           Id3Taginator.create_involved_person('involv2', 'involvee2')]
    tag.music_cd_identifier = 'cd toc'
    tag.play_counter = 42
    tag.popularity = Id3Taginator.create_popularimeter('e@mail.com', 0x05, 42)
    tag.recommended_buffer_size = Id3Taginator.create_buffer(500, false, nil)
    tag.ownership = Id3Taginator.create_ownership('$19.99', '12102021', 'seller')
    tag.add_private_frame(Id3Taginator.create_private_frame('owner_id', 'priv data'))
    tag.album = 'album'
    tag.bpm = 42
    tag.composers = %w[comp1 comp2]
    tag.genres = %i[ROCK METAL]
    tag.copyright = Id3Taginator.create_copyright(2020, 'holder')
    tag.date = Id3Taginator.create_date(9, 21)
    tag.playlist_delay = 42
    tag.encoded_by = 'encoded by'
    tag.writers = %w[writer1 writer2]
    tag.file_type = :MPEG_1_2_LAYER_III
    tag.time = Id3Taginator.create_time(5, 55)
    tag.content_group_description = 'content type description'
    tag.title = 'title'
    tag.subtitle = 'subtitle'
    tag.initial_key = 'Cbm'
    tag.languages = %w[eng ger]
    tag.length = 42
    tag.media_type = 'CD/A'
    tag.original_album = 'orig album'
    tag.original_filename = 'orig file name'
    tag.original_writers = %w[ow1 ow2]
    tag.original_artists = %w[oa1 oa2]
    tag.original_release_year = 2020
    tag.file_owner = 'file owner'
    tag.artists = %w[a1 a2]
    tag.album_artist = 'some band infos'
    tag.conductor = 'conductor'
    tag.modified_by = 'modified by'
    tag.part_of_set = Id3Taginator.create_part_of_set(1, 2)
    tag.publisher = 'publisher'
    tag.track_number = Id3Taginator.create_track_number(1, 12)
    tag.recording_dates = %w[date1 date2]
    tag.internet_radio_station_name = 'radio station'
    tag.album_sort_order = 'album sort'
    tag.performer_sort_order = 'performer sort'
    tag.title_sort_order = 'title sort'
    tag.isrc = '123456789987'
    tag.encoder = 'encoder'
    tag.add_user_custom_text_information(Id3Taginator.create_custom_user_text_info('descr', 'content'))
    tag.add_user_custom_text_information(Id3Taginator.create_custom_user_text_info('descr2', 'content2'))
    tag.year = 2021
    tag.add_unique_file_identifier(Id3Taginator.create_unique_file_identifier('owner_id', 'identifier'))
    tag.terms_of_use = Id3Taginator.create_terms_of_use('eng', 'ToU')
    tag.unsync_lyrics = Id3Taginator.create_unsync_lyrics('eng', 'descriptor', 'lyrics')
    tag.commercial_information_url = 'commercial info url'
    tag.copyright_information_url = 'copyright info url'
    tag.official_audio_file_url = 'official audio file url'
    tag.official_artist_url = 'official artist url'
    tag.official_source_url = 'official source url'
    tag.official_radio_station_homepage = 'official radio station homepage'
    tag.payment_url = 'payment url'
    tag.official_publisher_webpage = 'official publisher url'
    tag.add_user_custom_url_link(Id3Taginator.create_custom_url_link('description', 'url'))
    tag.add_user_custom_url_link(Id3Taginator.create_custom_url_link('description2', 'url2'))
  end

  def remove_frames(tag)
    tag.remove_audio_encryption('owner_id')
    tag.remove_picture('description')
    tag.remove_comment('eng', 'descriptor')
    tag.remove_encryption_method('owner_id')
    tag.remove_encapsulated_object('descriptor')
    tag.remove_group_identification('owner_id')
    tag.remove_grouping
    tag.remove_involved_people
    tag.remove_music_cd_identifier
    tag.remove_play_counter
    tag.remove_popularity
    tag.remove_recommended_buffer_size
    tag.remove_ownership
    tag.remove_private_frame('owner_id')
    tag.remove_album
    tag.remove_bpm
    tag.remove_composers
    tag.remove_genres
    tag.remove_copyright
    tag.remove_date
    tag.remove_playlist_delay
    tag.remove_encoded_by
    tag.remove_writers
    tag.remove_file_type
    tag.remove_time
    tag.remove_content_group_description
    tag.remove_title
    tag.remove_subtitle
    tag.remove_initial_key
    tag.remove_languages
    tag.remove_length
    tag.remove_media_type
    tag.remove_original_album
    tag.remove_original_filename
    tag.remove_original_writers
    tag.remove_original_artists
    tag.remove_original_release_year
    tag.remove_file_owner
    tag.remove_artists
    tag.remove_album_artist
    tag.remove_conductor
    tag.remove_modified_by
    tag.remove_part_of_set
    tag.remove_publisher
    tag.remove_track_number
    tag.remove_recording_dates
    tag.remove_internet_radio_station_name
    tag.remove_album_sort_order
    tag.remove_performer_sort_order
    tag.remove_title_sort_order
    tag.remove_isrc
    tag.remove_encoder
    tag.remove_user_custom_text_information('descr')
    tag.remove_user_custom_text_information('descr2')
    tag.remove_year
    tag.remove_unique_file_identifier('owner_id')
    tag.remove_terms_of_use
    tag.remove_unsync_lyrics('eng', 'descriptor')
    tag.remove_commercial_information_url
    tag.remove_copyright_information_url
    tag.remove_official_audio_file_url
    tag.remove_official_artist_url
    tag.remove_official_source_url
    tag.remove_official_radio_station_homepage
    tag.remove_payment_url
    tag.remove_official_publisher_webpage
    tag.remove_user_custom_url_link('description')
    tag.remove_user_custom_url_link('description2')
  end

  def write_id3v2_4_tag_mp3(input_file, output_file)
    audio_file = Id3Taginator.build_by_file(File.new(input_file))
    audio_file.remove_id3v1_tag
    audio_file.remove_id3v2_tag

    tag = audio_file.create_id3v2_4_tag
    add_frames(tag)

    audio_file.write_audio_file(output_file)
  end

  private :add_frames, :remove_frames
end
