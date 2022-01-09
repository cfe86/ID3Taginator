# frozen_string_literal: true

require_relative '../spec_helper'

RSpec.describe Id3Taginator::AudioFile do
  it 'writes an id3v1 tag and reads it' do
    audio_bytes = '00010203 04050607 08091011'
    audio_file = Id3Taginator.build_by_file(hex_string_to_byte_stream(audio_bytes))

    expect(audio_file.id3v1_tag).to be_nil
    tag = audio_file.create_id3v1_tag
    tag.title = 'tag title'
    tag.artist = 'tag artist'
    tag.album = 'tag album'
    tag.year = '2020'
    tag.comment = 'tag comment'
    tag.track = '1'
    tag.genre = :ROCK

    expect(audio_file.read_audio_data).to eq(hex_string_to_bytes(audio_bytes))

    audio_bytes_dump = audio_file.audio_file_to_bytes
    audio_file_dump = Id3Taginator.build_by_file(StringIO.new(audio_bytes_dump))

    tag_dump = audio_file_dump.id3v1_tag
    expect(tag.title).to eq(tag_dump.title)
    expect(tag.artist).to eq(tag_dump.artist)
    expect(tag.album).to eq(tag_dump.album)
    expect(tag.year).to eq(tag_dump.year)
    expect(tag.comment).to eq(tag_dump.comment)
    expect(tag.track).to eq(tag_dump.track)
    expect(tag.genre).to eq(tag_dump.genre)

    expect(audio_file.id3v2_tag).to eq(audio_file_dump.id3v2_tag)
  end
end
