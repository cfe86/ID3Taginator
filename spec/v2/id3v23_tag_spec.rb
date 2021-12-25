# frozen_string_literal: true

require_relative '../spec_helper'

RSpec.describe Id3Taginator::Id3v23Tag do
  it 'does read header flags correctly' do
    bytes = "ID3\x03\x00\xA0\x00\x00\x00\x03\x00\x00\x00"
    stream = StringIO.new(bytes)

    id3tag = Id3Taginator::Id3v2Tag.build_from_file(stream, Id3Taginator::Options::Options.new)

    expect(id3tag.version).to eq('2.3.0')
    expect(id3tag.total_tag_size).to eq(13)
    expect(id3tag.experimental?).to be_truthy
    expect(id3tag.extended_header?).to be_falsey
    expect(id3tag.unsynchronized?).to be_truthy
  end
end
