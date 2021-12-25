# frozen_string_literal: true

require_relative '../../spec_helper'

RSpec.describe Id3Taginator::Frames::Buffer::RecommendedBufferSizeFrame do
  subject { Id3Taginator::Frames::Buffer::RecommendedBufferSizeFrame }

  let!(:frame_id) { :RBUF }
  let!(:frame_id_v2) { :BUF }

  it 'reads buffer frame successful' do
    val = "\x00\x10\x10\x01"

    frame = test_frame_from_bytes(subject, frame_id, val)

    expect(frame.buffer_size).to eq(4112)
    expect(frame.embedded_info_flag).to eq(true)
    expect(frame.offset_next_tag).to eq(nil)
  end

  it 'reads buffer with offset frame successful' do
    val = "\x00\x10\x10\x01\x00\x00\x10\x10"

    frame = test_frame_from_bytes(subject, frame_id, val)

    expect(frame.buffer_size).to eq(4112)
    expect(frame.embedded_info_flag).to eq(true)
    expect(frame.offset_next_tag).to eq(4112)
  end

  it 'converts the buffer frame to bytes' do
    in_frame, parsed_frame = test_frame_to_bytes(subject, 4112, true, 4112)

    expect(in_frame.buffer_size).to eq(parsed_frame.buffer_size)
    expect(in_frame.embedded_info_flag).to eq(parsed_frame.embedded_info_flag)
    expect(in_frame.offset_next_tag).to eq(parsed_frame.offset_next_tag)
  end

  it 'converts the buffer with offset frame to bytes' do
    in_frame, parsed_frame = test_frame_to_bytes(subject, 4112, true, nil)

    expect(in_frame.buffer_size).to eq(parsed_frame.buffer_size)
    expect(in_frame.embedded_info_flag).to eq(parsed_frame.embedded_info_flag)
    expect(in_frame.offset_next_tag).to eq(parsed_frame.offset_next_tag)
  end
end
