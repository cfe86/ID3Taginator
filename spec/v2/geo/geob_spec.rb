# frozen_string_literal: true

require_relative '../../spec_helper'

RSpec.describe Id3Taginator::Frames::Geo::GeneralEncapsulatedObjectFrame do
  subject { Id3Taginator::Frames::Geo::GeneralEncapsulatedObjectFrame }

  let!(:frame_id) { :GEOB }

  it 'reads encapsulated object frame successful' do
    val = "\x01app/json\x00#{encode('filename.json', add_encoding_byte: false)}"\
          "#{encode('descriptor', add_encoding_byte: false)}binary data"

    frame = test_frame_from_bytes(subject, frame_id, val)

    expect(frame.mime_type).to eq('app/json')
    expect(frame.filename).to eq('filename.json')
    expect(frame.descriptor).to eq('descriptor')
    expect(frame.object_data).to eq('binary data')
  end

  it 'reads encapsulated object without mime/filename frame successful' do
    val = "\x01\x00#{encode('', add_encoding_byte: false)}"\
          "#{encode('descriptor', add_encoding_byte: false)}binary data"

    frame = test_frame_from_bytes(subject, frame_id, val)

    expect(frame.mime_type).to eq('')
    expect(frame.filename).to eq('')
    expect(frame.descriptor).to eq('descriptor')
    expect(frame.object_data).to eq('binary data')
  end

  it 'converts the encapsulated object frame to bytes' do
    in_frame, parsed_frame = test_frame_to_bytes(subject, 'app/json', 'filename.json', 'descriptor', 'binary data')

    expect(in_frame.mime_type).to eq(parsed_frame.mime_type)
    expect(in_frame.filename).to eq(parsed_frame.filename)
    expect(in_frame.descriptor).to eq(parsed_frame.descriptor)
    expect(in_frame.object_data).to eq(parsed_frame.object_data)
  end

  it 'converts the unsync without mime/filname frame to bytes' do
    in_frame, parsed_frame = test_frame_to_bytes(subject, nil, nil, 'descriptor', 'binary data')

    expect(in_frame.mime_type).to eq(parsed_frame.mime_type)
    expect(in_frame.filename).to eq(parsed_frame.filename)
    expect(in_frame.descriptor).to eq(parsed_frame.descriptor)
    expect(in_frame.object_data).to eq(parsed_frame.object_data)
  end
end
