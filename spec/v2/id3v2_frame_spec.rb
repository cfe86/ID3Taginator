# frozen_string_literal: true

require_relative '../spec_helper'

RSpec.describe Id3Taginator::Frames::Id3v2Frame do
  it 'does read header flags as set' do
    album_title = encode('My Album', Encoding::UTF_8, Encoding::UTF_16)

    bytes = "#{encode_str_to_hex('TALB', 8)}
    #{encoded_size_to_hex(album_title.bytes.length, 8)}
             E0 40
            #{encode_str_to_hex(album_title)}"

    stream = hex_string_to_byte_stream(bytes)
    frame_id = stream.read(4)
    frame = Id3Taginator::Frames::Text::AlbumFrame.build_v3_frame(frame_id, stream, Id3Taginator::Options::Options.new)

    expect(frame.tag_alter_preservation?).to be_truthy
    expect(frame.file_alter_preservation?).to be_truthy
    expect(frame.read_only?).to be_truthy
    expect(frame.compression?).to be_falsey
    expect(frame.encryption?).to be_truthy
    expect(frame.group_identity?).to be_falsey
  end

  it 'does read header flags as un-set' do
    album_title = encode('My Album', Encoding::UTF_8, Encoding::UTF_16)

    bytes = "#{encode_str_to_hex('TALB', 8)}
    #{encoded_size_to_hex(album_title.bytes.length, 8)}
             00 00
            #{encode_str_to_hex(album_title)}"

    stream = hex_string_to_byte_stream(bytes)
    frame_id = stream.read(4)
    frame = Id3Taginator::Frames::Text::AlbumFrame.build_v3_frame(frame_id, stream, Id3Taginator::Options::Options.new)

    expect(frame.tag_alter_preservation?).to be_falsey
    expect(frame.file_alter_preservation?).to be_falsey
    expect(frame.read_only?).to be_falsey
    expect(frame.compression?).to be_falsey
    expect(frame.encryption?).to be_falsey
    expect(frame.group_identity?).to be_falsey
  end
end
