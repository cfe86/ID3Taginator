# frozen_string_literal: true

require_relative '../../spec_helper'

RSpec.describe Id3Taginator::Frames::Picture::PictureFrame do
  subject { Id3Taginator::Frames::Picture::PictureFrame }

  let!(:frame_id) { :APIC }

  it 'reads picture frame successful' do
    val = "\x01image/png\x00\x03#{encode('descriptor', add_encoding_byte: false)}binary data of the picture"

    frame = test_frame_from_bytes(subject, frame_id, val)

    expect(frame.mime_type).to eq('image/png')
    expect(frame.picture_type).to eq(:COVER_FRONT)
    expect(frame.descriptor).to eq('descriptor')
    expect(frame.picture_data).to eq('binary data of the picture')
  end

  it 'reads picture without descriptor frame successful' do
    val = "\x01image/png\x00\x04#{encode('', add_encoding_byte: false)}binary data of the picture"

    frame = test_frame_from_bytes(subject, frame_id, val)

    expect(frame.mime_type).to eq('image/png')
    expect(frame.picture_type).to eq(:COVER_BACK)
    expect(frame.descriptor).to eq('')
    expect(frame.picture_data).to eq('binary data of the picture')
  end

  it 'reads picture with url reference frame successful' do
    val = "\x01-->\x00\x04#{encode('', add_encoding_byte: false)}https://www.my-pic.com"

    frame = test_frame_from_bytes(subject, frame_id, val)

    expect(frame.mime_type).to eq('-->')
    expect(frame.picture_type).to eq(:COVER_BACK)
    expect(frame.descriptor).to eq('')
    expect(frame.picture_data).to eq('https://www.my-pic.com')
  end

  it 'converts the picture frame to bytes' do
    in_frame, parsed_frame = test_frame_to_bytes(subject, 'png', :COVER_FRONT, 'Descr', 'binary data of the picture')

    expect(in_frame.mime_type).to eq(parsed_frame.mime_type)
    expect(in_frame.picture_type).to eq(parsed_frame.picture_type)
    expect(in_frame.descriptor).to eq(parsed_frame.descriptor)
    expect(in_frame.picture_data).to eq(parsed_frame.picture_data)
  end

  it 'converts the picture with url reference frame to bytes' do
    in_frame, parsed_frame = test_frame_to_bytes(subject, '-->', :COVER_FRONT, 'Descr', 'https://www.my-pic.com')

    expect(in_frame.mime_type).to eq(parsed_frame.mime_type)
    expect(in_frame.picture_type).to eq(parsed_frame.picture_type)
    expect(in_frame.descriptor).to eq(parsed_frame.descriptor)
    expect(in_frame.picture_data).to eq(parsed_frame.picture_data)
  end
end
