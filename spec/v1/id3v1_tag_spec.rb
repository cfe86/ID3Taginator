# frozen_string_literal: true

require_relative '../spec_helper'

RSpec.describe Id3Taginator::Id3v1Tag do
  it 'identifies itself as id3v1' do
    bytes = '54414745 73636170 65000000 00000000 00000000 00000000 00000000 00000000 00333020 5365636F 6E647320'\
            '546F204D 61727300 00000000 00000000 00000054 68697320 49732057 61720000 00000000 00000000 00000000'\
            '00000000 00323030 39000000 00000000 00000000 00000000 00000000 00000000 00000000 00000111'
    is_id3v1 = Id3Taginator::Id3v1Tag.id3v1_tag?(hex_string_to_byte_stream(bytes))
    expect(is_id3v1).to be_truthy
  end

  it 'reads id3v1 tag' do
    bytes = "544147
            #{encode_str_to_hex('title', 60)}
            #{encode_str_to_hex('artist', 60)}
            #{encode_str_to_hex('album', 60)}
            32303039
            #{encode_str_to_hex('comment', 58)}
            0111"
    idv3tag = Id3Taginator::Id3v1Tag.build_from_file(hex_string_to_byte_stream(bytes))

    expect(idv3tag.title).to eq('title')
    expect(idv3tag.artist).to eq('artist')
    expect(idv3tag.album).to eq('album')
    expect(idv3tag.year).to eq('2009')
    expect(idv3tag.comment).to eq('comment')
    expect(idv3tag.track).to eq(1)
    expect(idv3tag.genre).to eq(:ROCK)
  end

  it 'writes id3v1 tag' do
    tag_expected = Id3Taginator::Id3v1Tag.new('my title', 'my artist', 'my album', '2021',
                                              'my comment', 1, :ROCK)

    bytes = tag_expected.to_bytes
    tag_actual = Id3Taginator::Id3v1Tag.build_from_file(StringIO.new(bytes))

    expect(tag_expected.artist).to eq(tag_actual.artist)
    expect(tag_expected.album).to eq(tag_actual.album)
    expect(tag_expected.title).to eq(tag_actual.title)
    expect(tag_expected.comment).to eq(tag_actual.comment)
    expect(tag_expected.year).to eq(tag_actual.year)
    expect(tag_expected.track).to eq(tag_actual.track)
    expect(tag_expected.genre).to eq(tag_actual.genre)
  end
end
