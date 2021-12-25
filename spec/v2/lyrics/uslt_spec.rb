# frozen_string_literal: true

require_relative '../../spec_helper'

RSpec.describe Id3Taginator::Frames::Lyrics::UnsyncLyricsFrame do
  subject { Id3Taginator::Frames::Lyrics::UnsyncLyricsFrame }

  let!(:frame_id) { :USLT }

  it 'reads unsync lyrics no descriptor frame successful' do
    val = "\x01eng#{encode('', add_encoding_byte: false)}"\
          "#{encode("my lyrics\nblabla\nblub", add_encoding_byte: false, add_terminate_byte: false)}"

    frame = test_frame_from_bytes(subject, frame_id, val)

    expect(frame.language).to eq('eng')
    expect(frame.descriptor).to eq('')
    expect(frame.lyrics).to eq("my lyrics\nblabla\nblub")
  end

  it 'reads unsync lyrics with descriptor frame successful' do
    val = "\x01eng#{encode('descriptor', add_encoding_byte: false)}" \
          "#{encode("my lyrics\nblabla\nblub", add_encoding_byte: false, add_terminate_byte: false)}"

    frame = test_frame_from_bytes(subject, frame_id, val)

    expect(frame.language).to eq('eng')
    expect(frame.descriptor).to eq('descriptor')
    expect(frame.lyrics).to eq("my lyrics\nblabla\nblub")
  end

  it 'converts the unsync no descriptor lyrics frame to bytes' do
    in_frame, parsed_frame = test_frame_to_bytes(subject, 'eng', nil, "mylyrics\nblabla\nblub")

    expect(in_frame.language).to eq(parsed_frame.language)
    expect(in_frame.descriptor).to eq(parsed_frame.descriptor)
    expect(in_frame.lyrics).to eq(parsed_frame.lyrics)
  end

  it 'converts the unsync with descriptor lyrics frame to bytes' do
    in_frame, parsed_frame = test_frame_to_bytes(subject, 'eng', 'descriptor', "mylyrics\nblabla\nblub")

    expect(in_frame.language).to eq(parsed_frame.language)
    expect(in_frame.descriptor).to eq(parsed_frame.descriptor)
    expect(in_frame.lyrics).to eq(parsed_frame.lyrics)
  end
end
