# frozen_string_literal: true

require_relative '../spec_helper'

RSpec.describe Id3Taginator::AudioFile do
  it 'creates full audio file id3v2.2 and writes/reads it correctly' do
    audio_bytes = '00010203 04050607 08091011'
    audio_file = Id3Taginator.build_by_file(hex_string_to_byte_stream(audio_bytes))

    expect(audio_file.id3v2_tag).to be_nil
    tag = audio_file.create_id3v2_2_tag
    add_frames(tag)

    bytes = audio_file.audio_file_to_byte

    expect(audio_file.id3v2_tag).is_a?(Id3Taginator::Id3v22Tag)
    expect(audio_file.audio_data).to eq(hex_string_to_bytes(audio_bytes))

    audio_file_parsed = Id3Taginator.build_by_file(StringIO.new(bytes))

    expect(audio_file.id3v1_tag).to be_nil
    expect(audio_file.id3v2_tag).not_to be_nil

    tag = audio_file.id3v2_tag
    tag_parsed = audio_file_parsed.id3v2_tag

    expect(audio_file_parsed.id3v2_tag).is_a?(Id3Taginator::Id3v22Tag)
    expect(tag.recommended_buffer_size).to eq(tag_parsed.recommended_buffer_size)
    expect(tag.comments).to eq(tag_parsed.comments)
    expect(tag.play_counter).to eq(tag_parsed.play_counter)
    expect(tag.popularity).to eq(tag_parsed.popularity)
    expect(tag.audio_encryptions).to eq(tag_parsed.audio_encryptions)
    expect(tag.encapsulated_objects).to eq(tag_parsed.encapsulated_objects)
    expect(tag.involved_people).to eq(tag_parsed.involved_people)
    expect(tag.unsync_lyrics).to eq(tag_parsed.unsync_lyrics)
    expect(tag.music_cd_identifier).to eq(tag_parsed.music_cd_identifier)
    expect(tag.pictures).to eq(tag_parsed.pictures)
    expect(tag.unique_file_identifiers).to eq(tag_parsed.unique_file_identifiers)
    expect(tag.commercial_information_url).to eq(tag_parsed.commercial_information_url)
    expect(tag.copyright_information_url).to eq(tag_parsed.copyright_information_url)
    expect(tag.official_audio_file_url).to eq(tag_parsed.official_audio_file_url)
    expect(tag.official_artist_url).to eq(tag_parsed.official_artist_url)
    expect(tag.official_source_url).to eq(tag_parsed.official_source_url)
    expect(tag.official_publisher_webpage).to eq(tag_parsed.official_publisher_webpage)
    expect(tag.user_custom_url_links).to eq(tag_parsed.user_custom_url_links)

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
    expect(tag.artists).to eq(tag_parsed.artists)
    expect(tag.album_artist).to eq(tag_parsed.album_artist)
    expect(tag.conductor).to eq(tag_parsed.conductor)
    expect(tag.modified_by).to eq(tag_parsed.modified_by)
    expect(tag.part_of_set).to eq(tag_parsed.part_of_set)
    expect(tag.publisher).to eq(tag_parsed.publisher)
    expect(tag.track_number).to eq(tag_parsed.track_number)
    expect(tag.recording_dates).to eq(tag_parsed.recording_dates)
    expect(tag.size).to eq(tag_parsed.size)
    expect(tag.isrc).to eq(tag_parsed.isrc)
    expect(tag.encoder).to eq(tag_parsed.encoder)
    expect(tag.year).to eq(tag_parsed.year)
    expect(tag.user_custom_text_information).to eq(tag_parsed.user_custom_text_information)
  end

  it 'creates a id3v2.2 tag file' do
    file_path = '/Users/chris/mkv/30 Seconds To Mars-01-EscapeFull.mp3'
    file_path_out = '/Users/chris/mkv/30 Seconds To Mars-01-EscapeFull42.mp3'
    file = File.open(file_path)

    audio_file = Id3Taginator.build_by_file(file)
    tag = audio_file.create_id3v2_2_tag
    add_frames(tag)

    audio_file.write_audio_file(file_path_out)
  end

  def add_frames(tag)
    tag.recommended_buffer_size = Id3Taginator.create_buffer(500, false, nil)
    tag.comment = Id3Taginator.create_comment('eng', 'descriptor', 'comment')
    tag.play_counter = 42
    tag.popularity = Id3Taginator.create_popularimeter('e@mail.com', 0x05, 42)
    tag.add_audio_encryption(Id3Taginator.create_audio_encryption('owner_id', 42, 20, 'enc info'))
    tag.encapsulated_object = Id3Taginator.create_encapsulated_object('images/png', 'filename',
                                                                      'descriptor', 'data')
    tag.involved_people = [Id3Taginator.create_involved_person('involv1', 'involvee1'),
                           Id3Taginator.create_involved_person('involv2', 'involvee2')]
    tag.unsync_lyrics = Id3Taginator.create_unsync_lyrics('eng', 'descriptor', 'lyrics')
    tag.music_cd_identifier = 'cd toc'
    tag.add_picture(Id3Taginator.create_picture('images/png', :COVER_FRONT,
                                                'description', 'front cover'))
    tag.add_picture(Id3Taginator.create_picture('images/png', :COVER_BACK,
                                                'description', 'back cover'))
    tag.add_unique_file_identifier(Id3Taginator.create_unique_file_identifier('owner_id', 'identifier'))
    tag.commercial_information_url = 'commercial info url'
    tag.copyright_information_url = 'copyright info url'
    tag.official_audio_file_url = 'official audio file url'
    tag.official_artist_url = 'official artist url'
    tag.official_source_url = 'official source url'
    tag.official_publisher_webpage = 'official publisher url'
    tag.add_user_custom_url_link(Id3Taginator.create_custom_url_link('description', 'url'))
    tag.add_user_custom_url_link(Id3Taginator.create_custom_url_link('description2', 'url2'))

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
    tag.artists = %w[a1 a2]
    tag.album_artist = 'some band infos'
    tag.conductor = 'conductor'
    tag.modified_by = 'modified by'
    tag.part_of_set = Id3Taginator.create_part_of_set(1, 2)
    tag.publisher = 'publisher'
    tag.track_number = Id3Taginator.create_track_number(1, 12)
    tag.recording_dates = %w[date1 date2]
    tag.size = 42
    tag.isrc = '123456789987'
    tag.encoder = 'encoder'
    tag.year = 2021
    tag.add_user_custom_text_information(Id3Taginator.create_custom_user_text_info('descr', 'content'))
    tag.add_user_custom_text_information(Id3Taginator.create_custom_user_text_info('descr2', 'content2'))
  end

  private :add_frames
end
